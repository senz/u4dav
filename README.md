# µD4V lightweight WebDAV container image

µD4V (pronounced ooh-dove) is a container image targeting to be a lightweight, single-user WebDAV protocol server. 

Intended to be used in homelabs, i.e. for [Paperless-ngx](https://docs.paperless-ngx.com/) or [Calibre](https://calibre-ebook.com/) consumption directories frontend.

## Features

Core [WebDAV](https://datatracker.ietf.org/doc/html/rfc4918) support. Backed by [golang.org/x/net/webdav](https://pkg.go.dev/golang.org/x/net/webdav) and [caddy-webdav](https://github.com/mholt/caddy-webdav/tree/master)

Basic authz and serving powered by [Caddy](https://caddyserver.com)

Lightweight: image size ~87 MB, process mem consumption ~12 MB

## Usage

`docker pull ghcr.io/senz/u4dav:main`

Container env variables:

| Var name            | Description |
|---------------------|-------------|
| USERNAME            | User login for basic auth |
| PASSWORD            | Plaintext user password |
| CADDY_LOG_OUTPUT    | Where to send Caddy runtime logs: `stdout`, `stderr`, `discard`, or a file path. Default: `discard` |
| CADDY_LOG_LEVEL     | Minimum log level: `DEBUG`, `INFO`, `WARN`, `ERROR`. Default: `INFO` |

Mount your data under `/home/caddy/caddy-media` container folder.

Quick local test:
`docker run  -e USERNAME=ud4v -e PASSWORD=udaff -p 8080:80 -v ./media:/home/caddy/caddy-media ghcr.io/senz/u4dav:main`
