#!/usr/bin/env python3
"""usage: solidcraft-mcp.py <tool> [json-args] | --list

Images in a tool result are written to $SOLIDCRAFT_IMAGE_OUT (default ./solidcraft.png).
"""
import base64
import json
import os
import subprocess
import sys

CLI = "/Applications/SolidCraft.app/Contents/MacOS/solidcraft-cli"
CONTROL = os.path.expanduser("~/Library/Application Support/SolidCraft/control")


def connect():
    port = open(os.path.join(CONTROL, "current.port")).read().strip()
    token = open(os.path.join(CONTROL, f"{port}.token")).read().strip()
    return subprocess.Popen(
        [CLI, "mcp", "--connect", f"127.0.0.1:{port}", "--token", token, "--allow-any-path"],
        stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True,
    )


def main():
    proc = connect()

    def send(msg):
        proc.stdin.write(json.dumps(msg) + "\n")
        proc.stdin.flush()

    def recv(msg_id):
        for line in proc.stdout:
            msg = json.loads(line)
            if msg.get("id") == msg_id:
                return msg
        sys.exit("solidcraft-cli closed the connection")

    send({"jsonrpc": "2.0", "id": 0, "method": "initialize", "params": {
        "protocolVersion": "2025-06-18", "capabilities": {}, "clientInfo": {"name": "cad-modeling", "version": "0"}}})
    recv(0)
    send({"jsonrpc": "2.0", "method": "notifications/initialized"})

    if sys.argv[1] == "--list":
        send({"jsonrpc": "2.0", "id": 1, "method": "tools/list", "params": {}})
        print(json.dumps(recv(1)["result"], indent=1))
        return

    args = json.loads(sys.argv[2]) if len(sys.argv) > 2 else {}
    send({"jsonrpc": "2.0", "id": 1, "method": "tools/call", "params": {"name": sys.argv[1], "arguments": args}})
    reply = recv(1)
    if "error" in reply:
        sys.exit(json.dumps(reply["error"]))
    for item in reply["result"].get("content", []):
        if item.get("type") == "image":
            out = os.environ.get("SOLIDCRAFT_IMAGE_OUT", "solidcraft.png")
            with open(out, "wb") as f:
                f.write(base64.b64decode(item["data"]))
            print(f"image: {out}")
        else:
            print(item.get("text", ""))
    proc.terminate()
    if reply["result"].get("isError"):
        sys.exit(1)


if __name__ == "__main__":
    main()
