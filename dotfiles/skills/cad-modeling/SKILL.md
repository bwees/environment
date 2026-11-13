---
name: cad-modeling
description: Brandon's parametric CAD conventions for Fusion 360 and SolidCraft. Use when building, porting or editing a part, enclosure or case in Fusion 360 or SolidCraft, or when modeling around an imported PCB or purchased part.
---

# CAD modeling

Every shape is a **sketch plus an operation**. Every position comes from sketch geometry, never from moving a body.

## Rules

1. **Sketch → operation only.** Build solids from sketch profiles with extrude, revolve, sweep or loft, then fillet, chamfer, split or combine them. Leave out primitives (box, cylinder, sphere) and move or align commands on bodies and occurrences.
2. **Leave imports where they land.** A PCB or STEP import keeps its imported placement. The design is built around it, wherever it sits.
3. **One datum sketch per import.** When the part wraps imported geometry, a single plan-view sketch named `<Import> Datums` is the only feature that references the import:
   - It projects the import's outline edges as construction geometry.
   - It holds the layout (outer outline, pockets, lips, ribs) as construction geometry, dimensioned off those projected edges with parameters.
   - It holds anchor points (midpoints, or points on lines) for every plane the design needs.
   - Swapping the import means re-pointing the datum's projections and nothing else.
4. **Feature sketches project, they don't redraw.**
   - Plan-view sketches project datum curves (`construction: false`) and extrude them.
   - Wall and section sketches sit on construction planes that pass through datum anchor points.
   - An opening for a connector projects that connector's own face or edges, then offsets them or dimensions off them with a clearance parameter. Copying the connector's coordinates by hand is the thing to avoid.
5. **Parameters for shared values.**
   - A value used by more than one feature or part is a named user parameter (camelCase): stock and wall thickness, clearances, parting height, counts.
   - A one-off size stays a literal number in its sketch or feature.
6. **Simplest sketch that holds the intent.**
   - Use the fewest curves.
   - Put profile corner radii in the sketch, not as a later 3D fillet.
   - Let one sketch feed several operations through region picks.
   - Fully constrain the sketches other geometry depends on: datum and layout sketches, and anything that gets projected. A quick one-off sketch can stay partly constrained.
7. **Name what others navigate by.** Components, datum and layout sketches, and construction planes get names that say what they are (`Top Case`, `PCB Datums`, `Snap Front Plane`). Features can keep their default names.
8. **Holes use the Hole tool.** Every hole goes through the Hole feature (Fusion Hole, SolidCraft `solid.hole`), placed from sketch points. That covers screw clearance, tapped, counterbore and countersink holes. A cut-extruded circle is for round shapes that aren't holes.
9. **Sketches live in the component they build.**
   - Create the component first, activate it, then sketch and model inside it.
   - The only sketch in the top-level component is a datum sketch shared by several components. Each component's feature sketches project from it.

## Porting a design (Fusion → SolidCraft)

1. Dump the source timeline: sketches with curves and dimensions, features with extents, operations and target bodies, and final body volume, face count and centre of mass ([`tools.md`](tools.md)). Done when every timeline item up to the marker is listed and each multi-body feature is resolved to all the bodies it touches.
2. Write the build plan: parameters, the datum sketch contents, then each feature with its sketch, profiles and expected volume change.
3. Build in batches, one stage per batch. After each batch, `measure` and compare against the predicted change.
4. Verify: final volume, face count and COM against the source, timeline errors empty, then the **follow test** below. Report every geometric difference from the source, with its size.

## Follow test

The design follows its import. Prove it before calling the work done:

1. `edit.checkpoint`.
2. Shift the import (in SolidCraft, `occurrence.move` by a small `translate`). This is the only allowed move, and only inside this test.
3. Check: no timeline errors, case bodies keep their volume and face count, and the bbox shifts by exactly the move.
4. `edit.restore_checkpoint`. Then confirm `marker` is at the end and `active_sketch` is null.

Also run `check_parameters` on the main parameters (clearance, wall, parting height) and expect `errors: []`.

## Tooling

How to reach both MCP servers, the scripts in `scripts/`, and the traps found so far: [`tools.md`](tools.md). Read it before the first Fusion or SolidCraft call in a session.
