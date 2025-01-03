# https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/
# https://github.com/juvenn/caddy-dav

ARG CADDY_VERSION=2.9
FROM --platform=$BUILDPLATFORM caddy:${CADDY_VERSION}-builder-alpine AS builder
ARG BUILDPLATFORM
ARG TARGETPLATFORM
ARG TARGETOS TARGETARCH

RUN echo "Building for \"$TARGETOS/$TARGETARCH\" on \"$BUILDPLATFORM\"" && \
    echo "Caddy version: \"$CADDY_VERSION\"" && \
    GOOS="$TARGETOS" GOARCH="$TARGETARCH" xcaddy build "$CADDY_VERSION" \
        --with github.com/mholt/caddy-webdav && \
    echo "Built binary at: $(readlink -f caddy)"

FROM caddy:${CADDY_VERSION}-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY Caddyfile /etc/caddy/Caddyfile

RUN addgroup -g 1000 -S caddy && adduser -u 1000 -S caddy -G caddy -h /home/caddy && \
    mkdir -p /home/caddy/caddy-data /home/caddy/caddy-config /home/caddy/caddy-media && \
    chown -R caddy:caddy /home/caddy/caddy-data /home/caddy/caddy-config /home/caddy/caddy-media

USER caddy

EXPOSE 80 443
EXPOSE 443/udp

WORKDIR /srv

CMD ["/usr/bin/entrypoint.sh"]
