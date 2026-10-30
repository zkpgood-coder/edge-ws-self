# Build-from-repo variant for Buildfyio (Git source build).
# The fetch stage downloads the official Xray release and verifies the
# zip's SHA-256 against the value pinned below, which was checked
# against the official .dgst published with the same GitHub release
# on 2026-10-30. The build fails if the hash does not match.
# Runtime = the scripts extracted from edgerelay2610/edge-ws-cover
# and audited line by line on 2026-10-30 (dual-entry.sh + cover.py).
# No default UUID / WSPATH: the platform must supply them as env vars
# or the container refuses to start.
FROM alpine:3.20 AS fetch
ARG XRAY_VERSION=v26.10.29
ARG XRAY_SHA256=8a5f3e6a1057e4bd0f8a7c57c9d91204b4be0b74222a6e210d070603101163c2
RUN apk add --no-cache curl unzip
RUN curl -fsSL -o /tmp/xray.zip "https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-linux-64.zip" \
 && echo "${XRAY_SHA256}  /tmp/xray.zip" | sha256sum -c - \
 && mkdir -p /tmp/xray && unzip -o /tmp/xray.zip -d /tmp/xray

FROM alpine:3.20
RUN apk add --no-cache python3
COPY --from=fetch /tmp/xray/xray /usr/local/bin/xray
COPY --from=fetch /tmp/xray/geoip.dat /tmp/xray/geosite.dat /usr/local/share/xray/
COPY dual-entry.sh /dual-entry.sh
COPY cover.py /cover.py
RUN chmod +x /dual-entry.sh /cover.py /usr/local/bin/xray

ENV PORT=8080 XRAY_LOCATION_ASSET=/usr/local/share/xray
EXPOSE 8080
ENTRYPOINT ["/dual-entry.sh"]
