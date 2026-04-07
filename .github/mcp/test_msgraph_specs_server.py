#!/usr/bin/env python3
"""
Tests for msgraph-specs-server.py

Run:
  cd .github/mcp && python3 -m pytest test_msgraph_specs_server.py -v
"""

import json
import os
import sys
from pathlib import Path

import pytest


# ── Build a minimal test Graph spec tree ──────────────────────────────────────

@pytest.fixture()
def spec_tree(tmp_path):
    """
    Create a minimal msgraph-metadata mock:
      openapi/v1.0/openapi.yaml
      openapi/beta/openapi.yaml
    """
    v10_spec = {
        "openapi": "3.0.1",
        "info": {
            "title": "OData Service for namespace microsoft.graph",
            "description": "This OData service is located at https://graph.microsoft.com/v1.0",
            "version": "1.0.1",
        },
        "servers": [{"url": "https://graph.microsoft.com/v1.0"}],
        "paths": {
            "/organization": {
                "get": {
                    "tags": ["organization.organization"],
                    "summary": "List organization",
                    "operationId": "organization.organization.ListOrganization",
                    "parameters": [
                        {"name": "$select", "in": "query", "description": "Select properties", "schema": {"type": "array"}},
                    ],
                },
                "description": "Provides operations to manage the organization singleton.",
            },
            "/organization/{organization-id}": {
                "get": {
                    "tags": ["organization.organization"],
                    "summary": "Get organization",
                    "operationId": "organization.organization.GetOrganization",
                    "parameters": [
                        {"name": "organization-id", "in": "path", "required": True, "schema": {"type": "string"}},
                    ],
                },
                "patch": {
                    "tags": ["organization.organization"],
                    "summary": "Update organization",
                    "operationId": "organization.organization.UpdateOrganization",
                    "parameters": [
                        {"name": "organization-id", "in": "path", "required": True, "schema": {"type": "string"}},
                    ],
                    "requestBody": {
                        "required": True,
                        "content": {
                            "application/json": {
                                "schema": {"$ref": "#/components/schemas/Organization"},
                            },
                        },
                    },
                },
            },
            "/users": {
                "get": {
                    "tags": ["users.user"],
                    "summary": "List users",
                    "operationId": "users.user.ListUser",
                },
                "post": {
                    "tags": ["users.user"],
                    "summary": "Create user",
                    "operationId": "users.user.CreateUser",
                    "requestBody": {
                        "required": True,
                        "content": {
                            "application/json": {
                                "schema": {"$ref": "#/components/schemas/User"},
                            },
                        },
                    },
                },
            },
            "/users/{user-id}": {
                "get": {
                    "tags": ["users.user"],
                    "summary": "Get user",
                    "operationId": "users.user.GetUser",
                    "parameters": [
                        {"name": "user-id", "in": "path", "required": True, "schema": {"type": "string"}},
                    ],
                },
                "patch": {
                    "tags": ["users.user"],
                    "summary": "Update user",
                    "operationId": "users.user.UpdateUser",
                },
                "delete": {
                    "tags": ["users.user"],
                    "summary": "Delete user",
                    "operationId": "users.user.DeleteUser",
                },
            },
            "/tenantRelationships": {
                "get": {
                    "tags": ["tenantRelationships.tenantRelationship"],
                    "summary": "Get tenantRelationships",
                    "operationId": "tenantRelationships.tenantRelationship.GetTenantRelationship",
                },
            },
            "/applications": {
                "get": {
                    "tags": ["applications.application"],
                    "summary": "List applications",
                    "operationId": "applications.application.ListApplication",
                },
            },
        },
        "components": {
            "schemas": {
                "Organization": {
                    "type": "object",
                    "properties": {
                        "id": {"type": "string", "readOnly": True},
                        "displayName": {"type": "string"},
                        "verifiedDomains": {"type": "array", "readOnly": True},
                        "tenantType": {"type": "string"},
                        "createdDateTime": {"type": "string", "readOnly": True},
                    },
                },
                "User": {
                    "type": "object",
                    "properties": {
                        "id": {"type": "string", "readOnly": True},
                        "displayName": {"type": "string"},
                        "userPrincipalName": {"type": "string"},
                        "mail": {"type": "string"},
                        "accountEnabled": {"type": "boolean"},
                    },
                },
            },
        },
    }

    beta_spec = {
        "openapi": "3.0.1",
        "info": {
            "title": "OData Service for namespace microsoft.graph (beta)",
            "version": "beta",
        },
        "servers": [{"url": "https://graph.microsoft.com/beta"}],
        "paths": {
            "/organization": {
                "get": {
                    "tags": ["organization.organization"],
                    "summary": "List organization (beta)",
                    "operationId": "organization.organization.ListOrganization",
                },
            },
            "/tenantRelationships/multiTenantOrganization": {
                "get": {
                    "tags": ["tenantRelationships"],
                    "summary": "Get multiTenantOrganization",
                    "operationId": "tenantRelationships.GetMultiTenantOrganization",
                },
                "put": {
                    "tags": ["tenantRelationships"],
                    "summary": "Create multiTenantOrganization",
                    "operationId": "tenantRelationships.CreateMultiTenantOrganization",
                    "requestBody": {
                        "required": True,
                        "content": {
                            "application/json": {
                                "schema": {
                                    "type": "object",
                                    "properties": {
                                        "displayName": {"type": "string"},
                                    },
                                },
                            },
                        },
                    },
                },
            },
        },
        "components": {"schemas": {}},
    }

    # Write YAML files using json (valid YAML subset)
    v10_dir = tmp_path / "openapi" / "v1.0"
    v10_dir.mkdir(parents=True)
    (v10_dir / "openapi.yaml").write_text(json.dumps(v10_spec, indent=2), encoding="utf-8")

    beta_dir = tmp_path / "openapi" / "beta"
    beta_dir.mkdir(parents=True)
    (beta_dir / "openapi.yaml").write_text(json.dumps(beta_spec, indent=2), encoding="utf-8")

    return tmp_path


@pytest.fixture()
def server(spec_tree, monkeypatch):
    """Import msgraph_specs_server with REPO_ROOT pointed at the test tree."""
    monkeypatch.setenv("MSGRAPH_SPECS_ROOT", str(spec_tree))

    mod_name = "msgraph_specs_server"
    if mod_name in sys.modules:
        del sys.modules[mod_name]

    server_path = Path(__file__).parent / "msgraph-specs-server.py"
    import importlib.util
    spec = importlib.util.spec_from_file_location(mod_name, server_path)
    mod = importlib.util.module_from_spec(spec)
    mod.REPO_ROOT = spec_tree
    # Clear caches
    spec.loader.exec_module(mod)
    mod.REPO_ROOT = spec_tree
    mod._spec_cache.clear()
    mod._path_index.clear()
    mod._resource_groups.clear()
    return mod


# ═══════════════════════════════════════════════════════════════════════════════
# Tests
# ═══════════════════════════════════════════════════════════════════════════════


class TestListVersions:
    def test_returns_v10_and_beta(self, server):
        result = server.tool_list_versions({})
        versions = [v["version"] for v in result]
        assert "v1.0" in versions
        assert "beta" in versions

    def test_v10_is_stable(self, server):
        result = server.tool_list_versions({})
        v10 = [v for v in result if v["version"] == "v1.0"][0]
        assert v10["stability"] == "stable"

    def test_beta_is_preview(self, server):
        result = server.tool_list_versions({})
        beta = [v for v in result if v["version"] == "beta"][0]
        assert beta["stability"] == "preview"


class TestListResources:
    def test_v10_resources(self, server):
        result = server.tool_list_resources({"version": "v1.0"})
        assert "organization" in result
        assert "users" in result
        assert "applications" in result
        assert "tenantRelationships" in result

    def test_default_version(self, server):
        result = server.tool_list_resources({})
        assert "users" in result

    def test_beta_resources(self, server):
        result = server.tool_list_resources({"version": "beta"})
        assert "organization" in result
        assert "tenantRelationships" in result


class TestFindPath:
    def test_find_tenant(self, server):
        result = server.tool_find_path({"keyword": "tenant"})
        paths = [r["path"] for r in result]
        assert "/tenantRelationships" in paths

    def test_find_user(self, server):
        result = server.tool_find_path({"keyword": "user"})
        paths = [r["path"] for r in result]
        assert "/users" in paths

    def test_filter_by_method(self, server):
        result = server.tool_find_path({"keyword": "user", "method": "post"})
        assert all(r["method"] == "POST" for r in result)
        paths = [r["path"] for r in result]
        assert "/users" in paths

    def test_search_by_operation_id(self, server):
        result = server.tool_find_path({"keyword": "CreateUser"})
        assert len(result) >= 1
        op_ids = [r["operation_id"] for r in result]
        assert "users.user.CreateUser" in op_ids

    def test_beta_version(self, server):
        result = server.tool_find_path({"keyword": "multiTenant", "version": "beta"})
        assert len(result) >= 1
        paths = [r["path"] for r in result]
        assert "/tenantRelationships/multiTenantOrganization" in paths

    def test_limit(self, server):
        result = server.tool_find_path({"keyword": "user", "limit": 1})
        assert len(result) <= 1

    def test_no_results(self, server):
        result = server.tool_find_path({"keyword": "zzzznonexistent"})
        assert result == []


class TestGetOperation:
    def test_get_organization(self, server):
        result = server.tool_get_operation({"path": "/organization", "method": "get"})
        assert result["method"] == "GET"
        assert result["operation_id"] == "organization.organization.ListOrganization"

    def test_patch_organization_has_body(self, server):
        result = server.tool_get_operation({
            "path": "/organization/{organization-id}",
            "method": "patch",
        })
        assert "request_body" in result
        assert "displayName" in result["writable_properties"]
        assert "id" in result["readonly_properties"]

    def test_create_user(self, server):
        result = server.tool_get_operation({"path": "/users", "method": "post"})
        assert result["operation_id"] == "users.user.CreateUser"
        assert "request_body" in result
        assert "displayName" in result["writable_properties"]

    def test_path_not_found(self, server):
        with pytest.raises(ValueError, match="Path not found"):
            server.tool_get_operation({"path": "/nonexistent", "method": "get"})

    def test_method_not_found(self, server):
        with pytest.raises(ValueError, match="Method"):
            server.tool_get_operation({"path": "/organization", "method": "delete"})

    def test_parameters_extracted(self, server):
        result = server.tool_get_operation({
            "path": "/organization/{organization-id}",
            "method": "get",
        })
        param_names = [p["name"] for p in result["parameters"]]
        assert "organization-id" in param_names

    def test_beta_operation(self, server):
        result = server.tool_get_operation({
            "path": "/tenantRelationships/multiTenantOrganization",
            "method": "put",
            "version": "beta",
        })
        assert result["method"] == "PUT"
        assert "displayName" in result["writable_properties"]


class TestGetResourceSummary:
    def test_users_resource(self, server):
        result = server.tool_get_resource_summary({"resource": "users"})
        assert result["resource"] == "users"
        assert result["operation_count"] >= 4  # list, create, get, update, delete
        methods = {(op["path"], op["method"]) for op in result["operations"]}
        assert ("/users", "GET") in methods
        assert ("/users", "POST") in methods
        assert ("/users/{user-id}", "GET") in methods
        assert ("/users/{user-id}", "PATCH") in methods
        assert ("/users/{user-id}", "DELETE") in methods

    def test_organization_resource(self, server):
        result = server.tool_get_resource_summary({"resource": "organization"})
        assert result["operation_count"] >= 2

    def test_nonexistent_resource(self, server):
        with pytest.raises(ValueError, match="No operations found"):
            server.tool_get_resource_summary({"resource": "zzzznotreal"})

    def test_resource_with_leading_slash(self, server):
        result = server.tool_get_resource_summary({"resource": "/users"})
        assert result["operation_count"] >= 4


class TestInternalHelpers:
    def test_resolve_ref(self, server):
        spec = {"components": {"schemas": {"Foo": {"type": "object"}}}}
        result = server._resolve_ref("#/components/schemas/Foo", spec)
        assert result["type"] == "object"

    def test_resolve_missing_ref(self, server):
        result = server._resolve_ref("#/components/schemas/Missing", {"components": {"schemas": {}}})
        assert result == {}

    def test_inline_schema(self, server):
        spec = {
            "components": {"schemas": {"Bar": {"type": "object", "properties": {"x": {"type": "string"}}}}},
        }
        schema = {"$ref": "#/components/schemas/Bar"}
        result = server._inline_schema(schema, spec)
        assert "x" in result["properties"]

    def test_caching(self, server):
        """Loading the same version twice should use the cache."""
        server._load_spec("v1.0")
        assert "v1.0" in server._spec_cache
        # Second load should return same object
        s1 = server._load_spec("v1.0")
        s2 = server._load_spec("v1.0")
        assert s1 is s2
