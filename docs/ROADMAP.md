# Roadmap

Ideas and planned improvements for the Terraform rest-provider project.

## Azure MCP Server Enhancements

### 1. Property validation extraction tool

**Status:** Proposed  
**Impact:** High — eliminates manual spec reading for every module

Today, generating Terraform `validation` blocks requires:
1. Calling `azure-specs_read_spec` with a `json_path` targeting property definitions
2. Manually walking `enum`, `pattern`, `minLength`/`maxLength`, `minimum`/`maximum` from nested JSON
3. Translating constraints to HCL `validation` blocks by hand

A dedicated MCP tool would automate this entirely.

**Proposed tool:**
```
get_property_validations(spec_path, version, resource_type)
```

**Expected output:**
```json
{
  "kind": {
    "enum": ["Storage", "StorageV2", "BlobStorage", "FileStorage", "BlockBlobStorage"]
  },
  "sku.name": {
    "enum": ["Standard_LRS", "Standard_GRS", "Standard_RAGRS", "Standard_ZRS", "Premium_LRS", "Premium_ZRS", "Standard_GZRS", "Standard_RAGZRS"]
  },
  "properties.minimumTlsVersion": {
    "enum": ["TLS1_0", "TLS1_1", "TLS1_2"]
  },
  "properties.publicNetworkAccess": {
    "enum": ["Enabled", "Disabled", "SecuredByPerimeter"]
  },
  "properties.accessTier": {
    "enum": ["Hot", "Cool", "Cold", "Premium"]
  },
  "name": {
    "pattern": "^[a-z0-9]{3,24}$",
    "minLength": 3,
    "maxLength": 24
  }
}
```

**Benefits:**
- `tf-module` skill can auto-generate validation blocks at module creation time
- `tf-fix` skill can audit existing validations against the spec and detect drift
- Validation values stay in sync with the ARM API version (no hardcoded enums that go stale)
- Covers enums, regex patterns, length constraints, and numeric ranges
