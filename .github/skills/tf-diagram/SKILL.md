---
name: tf-diagram
description: "Visualize Terraform configuration as a Draw.io architecture diagram using the drawio MCP server. Uses vendor icon libraries (Azure, AWS, GCP) when available. Use when: create diagram, visualize config, draw architecture, tf_diagram, generate drawio, config.yaml to diagram, network diagram, infrastructure diagram, architecture visualization, drawio from terraform, visualize infrastructure, diagram from yaml"
argument-hint: "Path to config.yaml or description of what to diagram (e.g. 'config.yaml' or 'network topology')"
---

# tf-diagram

Generate a professional architecture diagram in Draw.io from a Terraform `config.yaml` configuration file, using vendor-specific icon libraries (Azure, AWS, GCP) when available.

**Scope**: This skill operates exclusively on `config.yaml` files that use this repo's convention of `ref:` cross-references between resources. It resolves those references to derive the full dependency graph. It does NOT parse `.tf` files directly.

## When to Use

- Visualize the infrastructure defined in a `config.yaml`
- Create or update an architecture diagram after config changes
- Generate a network topology or resource relationship diagram
- Produce a stakeholder-ready visual of the Terraform deployment

## Prerequisites

- A `.drawio` file must be **open in the VS Code editor** (the drawio MCP server communicates with the active editor)
- If no `.drawio` file exists, create one first and open it
- The drawio MCP server must be running (it starts automatically with the Draw.io VS Code extension)

## Procedure

### Step 1 — Parse the Configuration

Read the target `config.yaml` (default: workspace root `config.yaml`).

Extract:
1. **Resource groups** — these become region/location grouping containers
2. **Resource types** — each top-level key (e.g. `azure_virtual_wans`, `azure_virtual_hubs`, `azure_virtual_networks`, `azure_storage_accounts`, `azure_express_route_circuits`, etc.)
3. **Resources** — each named entry under a resource type
4. **References** — resolve ALL `ref:` values to build the full dependency graph. A `ref:` value like `ref:azure_virtual_wans.acme.id` means "this resource depends on the `acme` entry under `azure_virtual_wans`". Walk the entire config and collect every `ref:` to build a directed graph of dependencies.
5. **Locations** — group resources by `location` for spatial layout

Build a mental model:
- Locations → layers or grouped regions on the canvas
- Resource types → specific vendor icon shapes
- Resolved `ref:` links → edges (connections) between resources
- The dependency graph drives which edges to draw

### Step 2 — Discover Available Icon Libraries

Query the drawio MCP for vendor-specific shapes:

```
get-shape-categories → list all available shape categories
```

Look for categories matching the cloud vendor:
- **Azure**: look for categories containing "azure" (e.g. `Azure`, `Azure 2019`, `Azure 2021`)
- **AWS**: look for categories containing "aws" or `AWS`
- **GCP**: look for categories containing "gcp" or `Google Cloud`

Then for each relevant category:
```
get-shapes-in-category(categoryName: "<category>") → list shapes in that category
```

### Step 3 — Build the Shape Mapping

Map each Terraform resource type to the best matching vendor icon shape. Use `get-shape-by-name` to verify shapes exist.

**Azure resource type → Shape name mapping** (discover actual names via Step 2):

| Terraform resource type | Look for shape containing | Fallback |
|---|---|---|
| `azure_resource_groups` | `Resource Group`, `ResourceGroup` | Rectangle with label |
| `azure_virtual_wans` | `Virtual WAN`, `VirtualWAN` | Rectangle |
| `azure_virtual_hubs` | `Virtual Hub`, `VirtualHub` | Rectangle |
| `azure_virtual_networks` | `Virtual Network`, `VNet`, `VirtualNetwork` | Rectangle |
| `azure_storage_accounts` | `Storage Account`, `StorageAccount`, `Blob` | Rectangle |
| `azure_express_route_circuits` | `ExpressRoute`, `Express Route` | Rectangle |
| `azure_virtual_network_gateways` | `VPN Gateway`, `Virtual Network Gateway`, `ExpressRoute Gateway` | Rectangle |
| `azure_vpn_gateways` | `VPN Gateway`, `VPNGateway` | Rectangle |
| `azure_private_endpoints` | `Private Endpoint`, `PrivateEndpoint` | Small circle |
| `azure_key_vaults` | `Key Vault`, `KeyVault` | Rectangle |
| `azure_load_balancers` | `Load Balancer`, `LoadBalancer` | Rectangle |
| `azure_public_ip_addresses` | `Public IP`, `PublicIP` | Rectangle |
| `azure_firewall_policies` | `Firewall Policy`, `Firewall` | Rectangle |
| `azure_firewalls` | `Firewall`, `Azure Firewall` | Rectangle |
| `azure_route_tables` | `Route Table`, `RouteTable` | Rectangle |
| `azure_subscriptions` | `Subscription` | Rectangle |

If no vendor shape is found for a resource type, fall back to a styled rectangle with the resource type as label.

### Step 4 — Plan the Layout

Organize the diagram for **landscape display** using a **hub-and-spoke** layout centered on the core backbone (e.g. Virtual WAN).

1. **Create layers** for logical grouping:
   - One layer per **location/region** (e.g. `westus`, `israelcentral`)
   - A `global` layer for cross-region resources (Virtual WAN backbone)

2. **Layout strategy** — hub-and-spoke, landscape-optimized:
   - **Center**: Place the backbone/WAN resource in the middle of the canvas
   - **Spokes**: Radiate regions outward from center — left for Region 1, right for Region 2
   - **Within each region**: Stack hubs vertically, with connected VNets branching outward
   - **Resource groups**: Use containing rectangles to visually group resources by RG
   - **Leaf resources**: Place private endpoints, storage accounts, and gateways at the edges near their parent VNets
   - Optimize for wide (landscape) aspect ratio — spread horizontally, keep vertical compact

3. **Coordinate planning**:
   - Canvas center ~(800, 400) for landscape A4/widescreen
   - WAN backbone at center, regions spread ~600px to left and right
   - Within a region, hubs ~200px apart vertically
   - VNets branch ~300px outward from their hub
   - Resource group containers: ~500x600 minimum
   - Individual resource icons: ~48x48 to ~80x80 depending on importance

### Step 5 — Create the Diagram

Execute in this order using the drawio MCP tools:

#### 5a. Create layers
```
create-layer(label: "Global - WAN Backbone")
create-layer(label: "US West")
create-layer(label: "Israel Central")
```
Set the working layer before adding cells:
```
set-active-layer(layerId: "<layer-id>")
```

#### 5b. Add region grouping containers
For each resource group / region, add a large rectangle as a visual container:
```
add-rectangle(x: 0, y: 0, width: 600, height: 800, label: "US West\nrg-...", style: "rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontSize=14;fontStyle=1;verticalAlign=top;")
```

Use region-appropriate colors:
- Global/WAN: light gray `#f5f5f5`
- US West: light blue `#dae8fc`
- Israel Central: light green `#d5e8d4`

#### 5c. Add resource shapes
For each resource, use vendor icons when available:
```
add-cell-of-shape(shapeName: "<vendor-shape>", x: ..., y: ..., width: 48, height: 48, label: "<resource-display-name>")
```

If the shape is not found, fall back to:
```
add-rectangle(x: ..., y: ..., width: 120, height: 60, label: "<resource-name>", style: "rounded=1;whiteSpace=wrap;")
```

#### 5d. Add edges (connections)
For each `ref:` relationship in the config, add an edge:
```
add-edge(sourceId: "<source-cell-id>", targetId: "<target-cell-id>", label: "<relationship>")
```

Use meaningful labels:
- `ref:azure_virtual_wans.X.id` → edge label: "WAN"
- `ref:azure_resource_groups.X.resource_group_name` → no edge (containment, not connection)
- `ref:azure_storage_accounts.X.id` → edge label: "Private Link"
- `ref:azure_virtual_network_gateways.X.id` → edge label: "ExpressRoute"
- `ref:azure_express_route_circuits.X.id` → edge label: "Circuit"

**Default edge filtering** — skip these reference types (they represent containment or context, not connections):
- `resource_group_name` → containment, handled by spatial grouping
- `azure_subscriptions` / `subscription_id` → context, not a data-flow connection
- `tenant_id` → context, not a connection
- `location` → handled by region grouping

If the user **explicitly asks** to show containment, azure_subscriptions, or tenant relationships, include them as edges with a distinct dashed style: `strokeColor=#CCCCCC;strokeWidth=1;dashed=1;dashPattern=5 5;`

Edge styling by type:
- Network backbone: `strokeColor=#0078D4;strokeWidth=3;`
- ExpressRoute: `strokeColor=#FF8C00;strokeWidth=2;dashed=1;`
- Private endpoints: `strokeColor=#808080;strokeWidth=1;dashed=1;`
- VNet peering / hub connections: `strokeColor=#00A4EF;strokeWidth=2;`

### Step 6 — Verify and Refine

1. Use `list-paged-model` to review all cells and check completeness
2. Verify every resource from the config is represented
3. Verify every meaningful `ref:` has a corresponding edge
4. Check no cells overlap using coordinate review
5. Use `edit-cell` or `edit-edge` to fix labels, positions, or styles

## Style Guidelines

- **Font**: Use default font, size 11-12 for resources, 14 bold for group headers
- **Icons**: Prefer vendor library icons at 48x48; use 64x64 for key resources (hubs, gateways)
- **Colors**: Use the cloud vendor's brand palette for consistency
- **Labels**: Show the friendly name from the config key, not the full resource name
- **Line routing**: Use orthogonal routing for clean diagrams: `edgeStyle=orthogonalEdgeStyle;`

## Critical: MCP Parameter Names

The drawio MCP uses **snake_case** parameter names that differ from what you might expect:

| Tool | Key parameters (actual names) |
|---|---|
| `create-layer` | `name` (not `label`) |
| `set-active-layer` | `layer_id` (not `layerId`) |
| `add-rectangle` | `x`, `y`, `width`, `height`, `label`, `style` — **NOTE: `label` is ignored by the server; all rectangles get value "New Cell"** |
| `add-cell-of-shape` | `shape_name`, `x`, `y`, `width`, `height`, `label`, `style` — **`label` also ignored** |
| `add-edge` | `source_id`, `target_id`, `label`, `style` — **`label` also ignored** |
| `edit-cell` | `cell_id`, `text` (not `label`) — **This is how you set labels** |
| `edit-edge` | Similar pattern |
| `get-shapes-in-category` | `category_id` (not `categoryName`) |
| `get-shape-by-name` | `shape_name` (not `shapeName`) |

**IMPORTANT workflow**: Always create shapes first (labels will be "New Cell"), then immediately call `edit-cell(cell_id, text)` to set the actual label text. Do NOT rely on the `label` parameter of `add-rectangle` or `add-cell-of-shape`.

For edge labels, create the edge first, then use `edit-edge` to set the label text.

## Reference: drawio MCP Tool Summary

| Tool | Purpose |
|---|---|
| `get-shape-categories` | List all icon/shape library categories |
| `get-shapes-in-category` | List shapes in a category (use `category_id`) |
| `get-shape-by-name` | Find a specific shape by name (use `shape_name`) |
| `create-layer` | Create a named layer (use `name`) |
| `list-layers` | List existing layers |
| `set-active-layer` | Set which layer new cells go on (use `layer_id`) |
| `get-active-layer` | Get current active layer |
| `add-rectangle` | Add a basic rectangle (label ignored — use edit-cell after) |
| `add-cell-of-shape` | Add a cell using a named shape (label ignored — use edit-cell after) |
| `add-edge` | Connect two cells (use `source_id`, `target_id`; label ignored — use edit-edge after) |
| `edit-cell` | Set label via `text` param, also modify position/size/style |
| `edit-edge` | Modify an edge's label or style |
| `delete-cell-by-id` | Remove a cell |
| `set-cell-data` | Set custom metadata on a cell |
| `set-cell-shape` | Change shape of an existing cell |
| `move-cell-to-layer` | Move a cell to a different layer |
| `list-paged-model` | List all cells (paginated, use `page` + `page_size`) for review |
| `get-selected-cell` | Get currently selected cell in editor |
