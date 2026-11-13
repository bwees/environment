# CAD tooling

## Fusion 360 MCP

- Fusion serves MCP over HTTP at `http://127.0.0.1:27182/mcp`. It answers 403 unless the `Host` header is exactly `127.0.0.1:27182`.
- `scripts/fusion-mcp.sh <method> '<params-json>'` handles the session. Example: `fusion-mcp.sh tools/call '{"name":"fusion_mcp_read","arguments":{"queryType":"document","operation":"recent"}}'`.
- Tools: `fusion_mcp_read` (documents, screenshots, API docs), `fusion_mcp_execute` (`featureType: "script"` runs Python with `def run(_context: str)`; `print` output returns in `message`), `fusion_mcp_update` (undo, redo), `fusion_mcp_electronics_read`.
- Build script JSON with `json.dumps`, never by hand-quoting.
- `readOnly: true` scripts can't reach history: `referencePlane` of a face-attached sketch, extrude `participantBodies` and fillet `edges` all fail with "roll timeline back". Read those with a non-read-only script that calls `item.rollTo(True)` per item and restores `timeline.markerPosition` in a `finally`. `scripts/fusion-timeline-dump.py` does this.
- A feature that cuts or fillets bodies in several components shows up once per component (`component.features`), but `timelineItem.entity` returns only one of them. List features per component with their `timelineObject.index` to find the multi-body ones.
- Lengths from the API are cm. Multiply by 10.
- Read other designs without touching the user's active one: `app.documents.open(app.data.findFileById(id), False)`, then `close(False)`.

## SolidCraft MCP

- The app listens on a raw TCP control port (`~/Library/Application Support/SolidCraft/control/current.port`), with its token at `control/<port>.token`. The MCP server is `solidcraft-cli mcp --connect 127.0.0.1:<port> --token <token>`.
- `scripts/solidcraft-mcp.py <tool> '<json-args>'` wraps one call; `--list` lists tools. Load `skill_reference {"skill":"solidcraft-modeling"}` once per session for command shapes.
- `component.activate {"component":"root"}` before the first sketch. After an import the import's component is active, and a named plane like `"XY"` is that component's plane.
- Sketch frames:
  - `XZ`, and planes offset from it, map sketch x to +X and sketch y to **−Z**, with the normal along +Y.
  - `YZ` maps sketch x to +Y and sketch y to +Z, with the normal along +X.
  - `construct.plane.offset {base, through}` keeps the base plane's frame.
- Projection references:
  - `{sketch, curve}`, `{sketch, point}`, `{plane: "XY"}` (a z=0 reference line in a wall sketch) and `{edge|face|vertex, body}`.
  - Links follow the source when it moves.
  - Import links are stored by topological name (`F72:face:3`), so a re-import may break them. That's why only the datum sketch touches the import.
- Driven (reference) dimensions get no parameter, so measured import sizes can't feed expressions. Geometry links have to go through sketch constraints to projected curves.
- Use `connect: false` when drawing construction geometry that overlaps other geometry exactly. Otherwise auto-coincidences over-constrain the collinear constraints you add next.
- One sketch, several operations: pick regions with `profiles: [{point: [x, y]}]` and `exact_regions: true`. A curve chain whose ends land on another closed loop (T-junctions) splits regions correctly.
- `edit.restore_checkpoint` can leave a sketch open with the marker rolled back. Check `active_sketch` and `marker` after every restore. Fix with `sketch.finish` then `timeline.roll_to {}`.
- `measure` counts each instanced body; `inspect_design` counts definitions. Don't compare body counts across the two.
- Batch is all or nothing. Read `failed.index`, fix that step, and resend.
