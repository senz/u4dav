# µD4V lightweight WebDAV container image

µD4V (pronounced ooh-dove) is a container image targeting to be a lightweight, single-user WebDAV protocol server. 

Intended to be used in homelabs, i.e. for [Paperless-ngx](https://docs.paperless-ngx.com/) or [Calibre](https://calibre-ebook.com/) consumption directories frontend.

## Features

Core [WebDAV](https://datatracker.ietf.org/doc/html/rfc4918) support. Backed by [golang.org/x/net/webdav](https://pkg.go.dev/golang.org/x/net/webdav) and [caddy-webdav](https://github.com/mholt/caddy-webdav/tree/master)

Basic authz and serving powered by [Caddy](https://caddyserver.com)

Lightweight: image size ~87 MB, process mem consumption ~12 MB

## Usage

`docker pull ghcr.io/senz/u4dav:edge`

Container env variables:

| Var name            | Description |
|---------------------|-------------|
| USERNAME            | User login for basic auth |
| PASSWORD            | Plaintext user password |
| CADDY_LOG_OUTPUT    | Where to send Caddy runtime logs: `stdout`, `stderr`, `discard`, or a file path. Default: `discard` |
| CADDY_LOG_LEVEL              | Minimum log level: `INFO`, `ERROR`. Default: `INFO` |
| CADDY_REQUEST_BODY_MAX_SIZE  | Max size for request body (e.g. `1gb`, `100mb`). Default: `1gb` |

Mount your data under `/home/caddy/caddy-media` container folder.

Quick local test:
`docker run  -e USERNAME=ud4v -e PASSWORD=udaff -p 8080:80 -v ./media:/home/caddy/caddy-media ghcr.io/senz/u4dav:edge`

### Image tags

The image is published to [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry). Available tags:

| Tag | Description | Example |
|-----|-------------|---------|
| `edge` | Push to `main` | `ghcr.io/senz/u4dav:edge` |
| major | On semver tag push `v*` | `ghcr.io/senz/u4dav:2` |
| major.minor | Same | `ghcr.io/senz/u4dav:2.4` |
| full version | Same (no `v` prefix) | `ghcr.io/senz/u4dav:2.4.1` |

### Alternative image (rclone)

An alternative image serves WebDAV via [rclone serve webdav](https://rclone.org/commands/rclone_serve_webdav/) instead of Caddy. Same env vars `USERNAME`, `PASSWORD`; mount your data under `/media`. Use the `-rclone` tag suffix.

| Var name         | Description |
|------------------|-------------|
| USERNAME         | User login for basic auth |
| PASSWORD         | Plaintext user password |
| RCLONE_ADDR      | Listen address (default `:80`), e.g. `:8080` |
| RCLONE_LOG_LEVEL | Log level: `DEBUG`, `INFO`, `NOTICE`, `ERROR`. Default: `INFO` |

Example:

`docker run -e USERNAME=ud4v -e PASSWORD=udaff -p 8080:80 -v ./media:/media ghcr.io/senz/u4dav:edge-rclone`

