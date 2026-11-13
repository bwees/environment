#!/bin/bash
# usage: fusion-mcp.sh <jsonrpc-method> [params-json]
set -euo pipefail

URL=http://127.0.0.1:27182/mcp
SID_FILE="${FUSION_MCP_SID_FILE:-${TMPDIR:-/tmp}/fusion-mcp-session}"
HEADERS=(-H 'Host: 127.0.0.1:27182' -H 'Content-Type: application/json' -H 'Accept: application/json, text/event-stream')

open_session() {
  curl -s -D - -o /dev/null -X POST "$URL" "${HEADERS[@]}" \
    -d '{"jsonrpc":"2.0","id":0,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"cad-modeling","version":"0"}}}' \
    | awk 'tolower($1)=="mcp-session-id:"{print $2}' | tr -d '\r' > "$SID_FILE"
  curl -s -X POST "$URL" "${HEADERS[@]}" -H "MCP-Session-Id: $(cat "$SID_FILE")" \
    -d '{"jsonrpc":"2.0","method":"notifications/initialized"}' > /dev/null
}

[ -s "$SID_FILE" ] || open_session
curl -s -m 600 -X POST "$URL" "${HEADERS[@]}" -H "MCP-Session-Id: $(cat "$SID_FILE")" \
  -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"$1\",\"params\":${2:-null}}"
