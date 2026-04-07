---
description: "Apply Azure icon preferences when editing Draw.io diagrams. Use when: editing .drawio files, adding shapes to diagrams"
applyTo: "**/*.drawio"
---

When editing `.drawio` files for this project:

- Always prefer **Azure vendor icon libraries** (Azure 2019, Azure 2021, or latest available) over generic shapes
- Use `get-shape-categories` to discover available Azure libraries, then `get-shapes-in-category` to find the correct icon
- Use the hub-and-spoke layout pattern centered on backbone resources (Virtual WAN, hub VNets)
- Group resources by Azure region using colored containers
- Use orthogonal edge routing: `edgeStyle=orthogonalEdgeStyle;`
