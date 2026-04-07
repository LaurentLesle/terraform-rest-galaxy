#!/usr/bin/env python3
"""
Tests for azure-specs-server.py

Covers:
  - _is_version_container
  - _find_version_containers
  - _versions_for_container
  - tool_find_resource
  - tool_list_api_versions  (including the "path not found" bug for monolith specs)
  - tool_latest_stable_version
  - tool_get_spec_summary
  - _resolve_ref / _inline_schema
  - Monolith spec handling (network-style: single version container, many swagger files)
  - Per-resource-type spec handling (keyvault-style: one dir per resource type)

Run:
  cd .github/mcp && python3 -m pytest test_azure_specs_server.py -v
"""

import json
import os
import sys
import textwrap
from pathlib import Path

import pytest

# ── Build a temporary spec tree for testing ───────────────────────────────────

@pytest.fixture()
def spec_tree(tmp_path):
    """
    Create a minimal azure-rest-api-specs/specification/ tree that exercises
    both directory layouts:

    Layout A — flat / monolith (like Microsoft.Network):
      network/resource-manager/Microsoft.Network/Network/
        stable/2025-05-01/
          firewall.json          (contains AzureFirewalls PUT path)
          virtualNetwork.json    (contains VirtualNetworks PUT path)
        preview/2025-09-01-preview/
          firewall.json

    Layout B — per-resource-type (like Microsoft.KeyVault):
      keyvault/resource-manager/Microsoft.KeyVault/KeyVault/
        stable/2026-02-01/
          openapi.json

    Layout C — flat at provider level (like Microsoft.Storage):
      storage/resource-manager/Microsoft.Storage/
        stable/2025-08-01/
          openapi.json
        preview/2025-10-01-preview/
          openapi.json

    Layout D — nested resource type with own version container:
      resources/resource-manager/Microsoft.Resources/resources/
        stable/2025-04-01/
          resources.json
    """
    root = tmp_path / "specification"

    def _write_swagger(path: Path, content: dict) -> None:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(content, indent=2), encoding="utf-8")

    # ── Layout A: monolith network ────────────────────────────────────────
    net_stable = root / "network" / "resource-manager" / "Microsoft.Network" / "Network" / "stable" / "2025-05-01"
    _write_swagger(net_stable / "firewall.json", _make_swagger(
        title="NetworkManagementClient - Firewall",
        paths={
            "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/azureFirewalls/{azureFirewallName}": {
                "put": {
                    "operationId": "AzureFirewalls_CreateOrUpdate",
                    "summary": "Creates or updates the specified Azure Firewall.",
                    "x-ms-long-running-operation": True,
                    "x-ms-long-running-operation-options": {"final-state-via": "azure-async-operation"},
                    "parameters": [
                        {"name": "subscriptionId", "in": "path", "required": True, "type": "string"},
                        {"name": "resourceGroupName", "in": "path", "required": True, "type": "string"},
                        {"name": "azureFirewallName", "in": "path", "required": True, "type": "string"},
                        {"name": "api-version", "in": "query", "required": True, "type": "string"},
                        {"name": "parameters", "in": "body", "required": True, "schema": {"$ref": "#/definitions/AzureFirewall"}},
                    ],
                },
                "get": {"operationId": "AzureFirewalls_Get"},
                "delete": {"operationId": "AzureFirewalls_Delete", "x-ms-long-running-operation": True},
            },
        },
        definitions={
            "AzureFirewall": {
                "properties": {
                    "location": {"type": "string", "x-ms-mutability": ["create", "read"]},
                    "tags": {"type": "object"},
                    "properties": {
                        "type": "object",
                        "x-ms-client-flatten": True,
                        "properties": {
                            "provisioningState": {"type": "string", "readOnly": True},
                            "threatIntelMode": {"type": "string"},
                        },
                    },
                    "id": {"type": "string", "readOnly": True},
                    "name": {"type": "string", "readOnly": True},
                    "type": {"type": "string", "readOnly": True},
                },
            },
        },
    ))
    _write_swagger(net_stable / "virtualNetwork.json", _make_swagger(
        title="NetworkManagementClient - VirtualNetwork",
        paths={
            "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}": {
                "put": {"operationId": "VirtualNetworks_CreateOrUpdate", "x-ms-long-running-operation": True, "parameters": []},
            },
        },
    ))

    net_preview = root / "network" / "resource-manager" / "Microsoft.Network" / "Network" / "preview" / "2025-09-01-preview"
    _write_swagger(net_preview / "firewall.json", _make_swagger(
        title="NetworkManagementClient - Firewall (preview)",
        paths={},
    ))

    # ── Layout B: keyvault with resource type dir ─────────────────────────
    kv_stable = root / "keyvault" / "resource-manager" / "Microsoft.KeyVault" / "KeyVault" / "stable" / "2026-02-01"
    _write_swagger(kv_stable / "openapi.json", _make_swagger(
        title="KeyVaultManagementClient",
        paths={
            "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}": {
                "put": {"operationId": "Vaults_CreateOrUpdate", "x-ms-long-running-operation": True, "parameters": []},
            },
        },
    ))

    # ── Layout C: storage flat at provider level ──────────────────────────
    stor_stable = root / "storage" / "resource-manager" / "Microsoft.Storage" / "stable" / "2025-08-01"
    _write_swagger(stor_stable / "openapi.json", _make_swagger(
        title="StorageManagementClient",
        paths={
            "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}": {
                "put": {"operationId": "StorageAccounts_Create", "parameters": []},
            },
        },
    ))
    stor_preview = root / "storage" / "resource-manager" / "Microsoft.Storage" / "preview" / "2025-10-01-preview"
    _write_swagger(stor_preview / "openapi.json", _make_swagger(
        title="StorageManagementClient (preview)",
        paths={},
    ))

    # ── Layout D: resources/resources ─────────────────────────────────────
    res_stable = root / "resources" / "resource-manager" / "Microsoft.Resources" / "resources" / "stable" / "2025-04-01"
    _write_swagger(res_stable / "resources.json", _make_swagger(
        title="ResourceManagementClient",
        paths={
            "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}": {
                "put": {"operationId": "ResourceGroups_CreateOrUpdate", "parameters": []},
            },
        },
    ))

    # ── Layout E: CIAM-like (keyword only in swagger content, not in path) ──
    # Mimics cpim/resource-manager/Microsoft.AzureActiveDirectory/ExternalIdentities
    # where "ciam" and "tenant" don't appear in the path, only inside the swagger.
    ciam_preview = root / "cpim" / "resource-manager" / "Microsoft.AzureActiveDirectory" / "ExternalIdentities" / "preview" / "2023-05-17-preview"
    _write_swagger(ciam_preview / "externalIdentities.json", _make_swagger(
        title="ExternalIdentities",
        description="Manage the Azure resource for an Azure AD B2C tenant and Azure AD for customers",
        paths={
            "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureActiveDirectory/ciamDirectories/{resourceName}": {
                "put": {
                    "operationId": "CIAMTenants_Create",
                    "summary": "Create the Azure AD for customers tenant.",
                    "x-ms-long-running-operation": True,
                    "parameters": [],
                },
                "get": {"operationId": "CIAMTenants_Get"},
            },
            "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.AzureActiveDirectory/b2cDirectories/{resourceName}": {
                "put": {
                    "operationId": "B2CTenants_Create",
                    "summary": "Create the Azure AD B2C tenant.",
                    "x-ms-long-running-operation": True,
                    "parameters": [],
                },
            },
        },
        definitions={
            "CIAMTenantResource": {"type": "object", "properties": {"location": {"type": "string"}}},
            "CreateCIAMTenantProperties": {"type": "object", "properties": {"displayName": {"type": "string"}}},
        },
    ))

    return root


def _make_swagger(title="Test", paths=None, definitions=None, description=None) -> dict:
    """Helper to create a minimal valid swagger document."""
    info = {"title": title, "version": "2025-05-01"}
    if description:
        info["description"] = description
    doc = {
        "swagger": "2.0",
        "info": info,
        "host": "management.azure.com",
        "basePath": "/",
        "schemes": ["https"],
        "paths": paths or {},
    }
    if definitions:
        doc["definitions"] = definitions
    return doc


# ── Helpers to import the server module ───────────────────────────────────────

@pytest.fixture()
def server(spec_tree, monkeypatch):
    """
    Import azure_specs_server with SPECS_ROOT pointed at the test tree.
    Returns the module object.
    """
    monkeypatch.setenv("AZURE_SPECS_ROOT", str(spec_tree))

    # Remove cached module if present so SPECS_ROOT is re-evaluated
    mod_name = "azure_specs_server"
    if mod_name in sys.modules:
        del sys.modules[mod_name]

    server_path = Path(__file__).parent / "azure-specs-server.py"
    import importlib.util
    spec = importlib.util.spec_from_file_location(mod_name, server_path)
    mod = importlib.util.module_from_spec(spec)
    # Patch SPECS_ROOT before executing the module
    mod.SPECS_ROOT = spec_tree
    spec.loader.exec_module(mod)
    mod.SPECS_ROOT = spec_tree  # ensure it sticks after exec
    mod._search_index = None  # reset cached search index between tests
    return mod


# ═══════════════════════════════════════════════════════════════════════════════
# Tests
# ═══════════════════════════════════════════════════════════════════════════════


class TestIsVersionContainer:
    def test_true_when_stable_exists(self, server, spec_tree):
        p = spec_tree / "storage" / "resource-manager" / "Microsoft.Storage"
        assert server._is_version_container(p) is True

    def test_true_for_monolith_network(self, server, spec_tree):
        p = spec_tree / "network" / "resource-manager" / "Microsoft.Network" / "Network"
        assert server._is_version_container(p) is True

    def test_false_for_non_container(self, server, spec_tree):
        p = spec_tree / "network" / "resource-manager" / "Microsoft.Network"
        assert server._is_version_container(p) is False


class TestFindVersionContainers:
    def test_finds_network_monolith(self, server, spec_tree):
        containers = server._find_version_containers(spec_tree / "network")
        paths = [c.relative_to(spec_tree).as_posix() for c in containers]
        assert "network/resource-manager/Microsoft.Network/Network" in paths

    def test_finds_keyvault(self, server, spec_tree):
        containers = server._find_version_containers(spec_tree / "keyvault")
        paths = [c.relative_to(spec_tree).as_posix() for c in containers]
        assert "keyvault/resource-manager/Microsoft.KeyVault/KeyVault" in paths


class TestVersionsForContainer:
    def test_stable_and_preview(self, server, spec_tree):
        p = spec_tree / "network" / "resource-manager" / "Microsoft.Network" / "Network"
        versions = server._versions_for_container(p)
        stabilities = {v["stability"] for v in versions}
        assert "stable" in stabilities
        assert "preview" in stabilities

    def test_sorted_newest_first(self, server, spec_tree):
        p = spec_tree / "network" / "resource-manager" / "Microsoft.Network" / "Network"
        versions = server._versions_for_container(p)
        version_strs = [v["version"] for v in versions]
        assert version_strs == sorted(version_strs, reverse=True)


class TestToolFindResource:
    def test_find_network(self, server):
        results = server.tool_find_resource({"keyword": "Network"})
        paths = [r["spec_path"] for r in results]
        assert "network/resource-manager/Microsoft.Network/Network" in paths

    def test_find_keyvault(self, server):
        results = server.tool_find_resource({"keyword": "KeyVault"})
        paths = [r["spec_path"] for r in results]
        assert "keyvault/resource-manager/Microsoft.KeyVault/KeyVault" in paths

    def test_find_storage(self, server):
        results = server.tool_find_resource({"keyword": "Storage"})
        paths = [r["spec_path"] for r in results]
        assert "storage/resource-manager/Microsoft.Storage" in paths

    def test_latest_stable_populated(self, server):
        results = server.tool_find_resource({"keyword": "Storage"})
        storage = [r for r in results if "Microsoft.Storage" in r["spec_path"]][0]
        assert storage["latest_stable_version"] == "2025-08-01"


class TestToolListApiVersions:
    def test_direct_container(self, server):
        """Path that IS a version container should work directly."""
        result = server.tool_list_api_versions({"spec_path": "storage/resource-manager/Microsoft.Storage"})
        versions = [v["version"] for v in result]
        assert "2025-08-01" in versions

    def test_monolith_container(self, server):
        """Path to the actual Network monolith container should work."""
        result = server.tool_list_api_versions({"spec_path": "network/resource-manager/Microsoft.Network/Network"})
        versions = [v["version"] for v in result]
        assert "2025-05-01" in versions

    def test_nonexistent_sub_path_falls_back(self, server):
        """
        Paths like 'network/resource-manager/Microsoft.Network/azureFirewalls'
        don't exist as directories. After fix, the server falls back to the
        sibling version container (Microsoft.Network/Network).
        """
        result = server.tool_list_api_versions(
            {"spec_path": "network/resource-manager/Microsoft.Network/azureFirewalls"}
        )
        versions = [v["version"] for v in result]
        assert "2025-05-01" in versions

    def test_nonexistent_sub_path_now_falls_back(self, server):
        """
        After fix: paths like 'network/resource-manager/Microsoft.Network/azureFirewalls'
        should fall back to the sibling version container and return its versions.
        """
        result = server.tool_list_api_versions(
            {"spec_path": "network/resource-manager/Microsoft.Network/azureFirewalls"}
        )
        versions = [v["version"] for v in result]
        assert "2025-05-01" in versions


class TestToolLatestStableVersion:
    def test_storage(self, server):
        result = server.tool_latest_stable_version({"spec_path": "storage/resource-manager/Microsoft.Storage"})
        assert result["version"] == "2025-08-01"
        assert result["stability"] == "stable"

    def test_keyvault(self, server):
        result = server.tool_latest_stable_version(
            {"spec_path": "keyvault/resource-manager/Microsoft.KeyVault/KeyVault"}
        )
        assert result["version"] == "2026-02-01"

    def test_network_monolith_direct(self, server):
        """Using the actual monolith path should work."""
        result = server.tool_latest_stable_version(
            {"spec_path": "network/resource-manager/Microsoft.Network/Network"}
        )
        assert result["version"] == "2025-05-01"

    def test_network_virtual_sub_path_fallback(self, server):
        """
        After fix: virtual sub-paths like 'azureFirewalls' fall back to the
        sibling version container and return the latest stable version.
        """
        result = server.tool_latest_stable_version(
            {"spec_path": "network/resource-manager/Microsoft.Network/azureFirewalls"}
        )
        assert result["version"] == "2025-05-01"

    def test_resources(self, server):
        result = server.tool_latest_stable_version(
            {"spec_path": "resources/resource-manager/Microsoft.Resources/resources"}
        )
        assert result["version"] == "2025-04-01"


class TestToolGetSpecSummary:
    def test_firewall_summary(self, server):
        summary = server.tool_get_spec_summary({
            "spec_path": "network/resource-manager/Microsoft.Network/Network",
            "version": "2025-05-01",
            "swagger_file": "firewall.json",
        })
        assert summary["title"] == "NetworkManagementClient - Firewall"
        # Should have the PUT path
        put_ops = [p for p in summary["paths"] if p["method"] == "PUT"]
        assert len(put_ops) >= 1
        assert "azureFirewalls" in put_ops[0]["path"]

    def test_readonly_properties_detected(self, server):
        summary = server.tool_get_spec_summary({
            "spec_path": "network/resource-manager/Microsoft.Network/Network",
            "version": "2025-05-01",
            "swagger_file": "firewall.json",
        })
        put_ops = [p for p in summary["paths"] if p["method"] == "PUT"]
        assert len(put_ops) >= 1
        put_op = put_ops[0]
        assert "id" in put_op.get("readonly_properties", [])
        assert "name" in put_op.get("readonly_properties", [])

    def test_writable_properties_detected(self, server):
        summary = server.tool_get_spec_summary({
            "spec_path": "network/resource-manager/Microsoft.Network/Network",
            "version": "2025-05-01",
            "swagger_file": "firewall.json",
        })
        put_ops = [p for p in summary["paths"] if p["method"] == "PUT"]
        assert len(put_ops) >= 1
        put_op = put_ops[0]
        assert "tags" in put_op.get("writable_properties", [])

    def test_long_running_flag(self, server):
        summary = server.tool_get_spec_summary({
            "spec_path": "network/resource-manager/Microsoft.Network/Network",
            "version": "2025-05-01",
            "swagger_file": "firewall.json",
        })
        put_ops = [p for p in summary["paths"] if p["method"] == "PUT"]
        assert put_ops[0]["long_running"] is True
        assert put_ops[0]["long_running_final_state_via"] == "azure-async-operation"

    def test_wrong_version_raises(self, server):
        with pytest.raises(ValueError, match="not found"):
            server.tool_get_spec_summary({
                "spec_path": "network/resource-manager/Microsoft.Network/Network",
                "version": "9999-01-01",
            })


class TestResolveRef:
    def test_local_ref(self, server):
        spec = {"definitions": {"Foo": {"type": "object", "properties": {"bar": {"type": "string"}}}}}
        result = server._resolve_ref("#/definitions/Foo", spec)
        assert result["type"] == "object"
        assert "bar" in result["properties"]

    def test_missing_ref(self, server):
        result = server._resolve_ref("#/definitions/Missing", {"definitions": {}})
        assert result == {}

    def test_external_ref_returns_empty(self, server):
        result = server._resolve_ref("./other-file.json#/definitions/Foo", {})
        assert result == {}


class TestInlineSchema:
    def test_inline_ref(self, server):
        spec = {
            "definitions": {
                "Foo": {"type": "object", "properties": {"bar": {"type": "string"}}},
            }
        }
        schema = {"$ref": "#/definitions/Foo"}
        result = server._inline_schema(schema, spec)
        assert "bar" in result.get("properties", {})

    def test_allof_flattened(self, server):
        spec = {
            "definitions": {
                "Base": {"properties": {"id": {"type": "string"}}},
            }
        }
        schema = {
            "allOf": [
                {"$ref": "#/definitions/Base"},
                {"properties": {"name": {"type": "string"}}},
            ]
        }
        result = server._inline_schema(schema, spec)
        props = result.get("properties", {})
        assert "id" in props
        assert "name" in props
        assert "allOf" not in result


class TestToolListServices:
    def test_all_services(self, server):
        services = server.tool_list_services({})
        assert "network" in services
        assert "keyvault" in services
        assert "storage" in services

    def test_filter_keyword(self, server):
        services = server.tool_list_services({"keyword": "net"})
        assert "network" in services
        assert "storage" not in services


class TestToolListPlanes:
    def test_network_has_resource_manager(self, server):
        planes = server.tool_list_planes({"service": "network"})
        assert "resource-manager" in planes

    def test_missing_service_raises(self, server):
        with pytest.raises(ValueError, match="not found"):
            server.tool_list_planes({"service": "nonexistent"})


class TestMonolithSwaggerFileHint:
    """
    For monolith specs (like Network), the swagger_file parameter in
    get_spec_summary should select the right file (e.g. firewall.json
    vs virtualNetwork.json).
    """

    def test_select_firewall(self, server):
        summary = server.tool_get_spec_summary({
            "spec_path": "network/resource-manager/Microsoft.Network/Network",
            "version": "2025-05-01",
            "swagger_file": "firewall.json",
        })
        assert "Firewall" in summary["title"]

    def test_select_virtualnetwork(self, server):
        summary = server.tool_get_spec_summary({
            "spec_path": "network/resource-manager/Microsoft.Network/Network",
            "version": "2025-05-01",
            "swagger_file": "virtualNetwork.json",
        })
        assert "VirtualNetwork" in summary["title"]

    def test_auto_select_first(self, server):
        """When no swagger_file given, picks the first alphabetically."""
        summary = server.tool_get_spec_summary({
            "spec_path": "network/resource-manager/Microsoft.Network/Network",
            "version": "2025-05-01",
        })
        # firewall.json comes before virtualNetwork.json alphabetically
        assert "Firewall" in summary["title"]


class TestFallbackResolution:
    """
    Tests for the fallback resolution feature.

    When spec_path points to a non-existent sub-directory (e.g.
    'network/resource-manager/Microsoft.Network/azureFirewalls'), the server
    should walk up to find the nearest parent version container
    ('network/resource-manager/Microsoft.Network/Network') and use it.

    These tests document the EXPECTED behaviour after the fix.
    They will fail until the fix is applied.
    """

    def test_list_api_versions_fallback(self, server):
        """
        'network/resource-manager/Microsoft.Network/azureFirewalls'
        should fall back to the parent version container and return its versions.
        """
        try:
            result = server.tool_list_api_versions(
                {"spec_path": "network/resource-manager/Microsoft.Network/azureFirewalls"}
            )
            # If it didn't raise, the fix is in place
            versions = [v["version"] for v in result] if isinstance(result, list) and "version" in result[0] else []
            assert "2025-05-01" in versions
        except ValueError:
            pytest.fail(
                "tool_list_api_versions should fall back to the nearest parent version "
                "container when spec_path doesn't exist. Got ValueError instead."
            )

    def test_latest_stable_version_fallback(self, server):
        """
        'network/resource-manager/Microsoft.Network/virtualNetworks'
        should fall back and return the latest stable version from the parent.
        """
        try:
            result = server.tool_latest_stable_version(
                {"spec_path": "network/resource-manager/Microsoft.Network/virtualNetworks"}
            )
            assert result["version"] == "2025-05-01"
        except ValueError:
            pytest.fail(
                "tool_latest_stable_version should fall back to the nearest parent "
                "version container. Got ValueError instead."
            )

    def test_fallback_finds_sibling_container(self, server):
        """
        When the exact path doesn't exist, but a sibling version container does
        under the same parent, use that sibling.

        e.g. Microsoft.Network/azureFirewalls → Microsoft.Network/Network
        """
        try:
            result = server.tool_latest_stable_version(
                {"spec_path": "network/resource-manager/Microsoft.Network/routeTables"}
            )
            assert result["version"] == "2025-05-01"
        except ValueError:
            pytest.fail(
                "Should find sibling version container when exact path doesn't exist."
            )

    def test_completely_wrong_path_still_raises(self, server):
        """A completely bogus path should still raise ValueError."""
        with pytest.raises(ValueError):
            server.tool_list_api_versions(
                {"spec_path": "nonexistent/totally/wrong/path"}
            )


class TestFindResourceDeepSearch:
    """
    Tests for the deep-search feature in find_resource.
    Verifies that keywords appearing only inside swagger content (API paths,
    definitions, operationIds, summaries, title, description) — but NOT in the
    directory path — are matched correctly.

    Uses Layout E (CIAM-like: cpim/.../ExternalIdentities) where "ciam",
    "tenant", and "b2c" only appear inside the swagger file.
    """

    def test_find_by_api_path_keyword(self, server):
        """'ciam' appears in /ciamDirectories path but not in directory name."""
        results = server.tool_find_resource({"keyword": "ciam"})
        paths = [r["spec_path"] for r in results]
        assert "cpim/resource-manager/Microsoft.AzureActiveDirectory/ExternalIdentities" in paths

    def test_find_by_definition_name(self, server):
        """'CIAMTenantResource' definition should be searchable."""
        results = server.tool_find_resource({"keyword": "CIAMTenantResource"})
        paths = [r["spec_path"] for r in results]
        assert "cpim/resource-manager/Microsoft.AzureActiveDirectory/ExternalIdentities" in paths

    def test_find_by_operation_id(self, server):
        """'CIAMTenants_Create' operationId should be searchable."""
        results = server.tool_find_resource({"keyword": "CIAMTenants_Create"})
        paths = [r["spec_path"] for r in results]
        assert "cpim/resource-manager/Microsoft.AzureActiveDirectory/ExternalIdentities" in paths

    def test_find_by_summary_keyword(self, server):
        """'customers' appears only in the operation summary text."""
        results = server.tool_find_resource({"keyword": "customers"})
        paths = [r["spec_path"] for r in results]
        assert "cpim/resource-manager/Microsoft.AzureActiveDirectory/ExternalIdentities" in paths

    def test_find_by_description_keyword(self, server):
        """'B2C tenant' appears in the spec description."""
        results = server.tool_find_resource({"keyword": "b2c tenant"})
        paths = [r["spec_path"] for r in results]
        assert "cpim/resource-manager/Microsoft.AzureActiveDirectory/ExternalIdentities" in paths

    def test_find_tenant_includes_ciam(self, server):
        """'tenant' should match ExternalIdentities via swagger content (the original bug)."""
        results = server.tool_find_resource({"keyword": "tenant"})
        paths = [r["spec_path"] for r in results]
        assert "cpim/resource-manager/Microsoft.AzureActiveDirectory/ExternalIdentities" in paths

    def test_path_match_still_works(self, server):
        """Keywords matching directory path parts should still work as before."""
        results = server.tool_find_resource({"keyword": "ExternalIdentities"})
        paths = [r["spec_path"] for r in results]
        assert "cpim/resource-manager/Microsoft.AzureActiveDirectory/ExternalIdentities" in paths

    def test_no_duplicates_when_both_match(self, server):
        """When keyword matches both path and content, result should appear only once."""
        results = server.tool_find_resource({"keyword": "ExternalIdentities"})
        ext_id_results = [r for r in results if "ExternalIdentities" in r["spec_path"]]
        assert len(ext_id_results) == 1

    def test_nonexistent_keyword_returns_empty(self, server):
        """A keyword that matches nothing should return empty list."""
        results = server.tool_find_resource({"keyword": "zzz_nonexistent_zzz"})
        assert results == []

    def test_case_insensitive_deep_search(self, server):
        """Deep search should be case-insensitive."""
        results = server.tool_find_resource({"keyword": "CIAMTENANTS_CREATE"})
        paths = [r["spec_path"] for r in results]
        assert "cpim/resource-manager/Microsoft.AzureActiveDirectory/ExternalIdentities" in paths
