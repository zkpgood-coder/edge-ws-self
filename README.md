# edge-ws-self

A small WebSocket cover front for an Xray VLESS inbound, packaged for
Buildfyio's Git build.

- Xray is downloaded from the official XTLS release at build time and
  verified by SHA-256 (pinned in the Dockerfile) before installation.
- The two runtime scripts (dual-entry.sh, cover.py) come from a public
  container image and were reviewed line by line before reuse.
- Required env vars at deploy time: UUID, WSPATH. PORT defaults to 8080.
  There is intentionally no default UUID or path in the image.
