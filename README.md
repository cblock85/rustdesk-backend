# rustdesk-backend

A self-hosted backend for [RustDesk](https://github.com/rustdesk/rustdesk)
clients in one container: ID server, relay server, API server and a web admin
panel, with login enforcement that covers every connection path.

It is built on [lejianwen's](https://github.com/lejianwen) server and API
projects, which are no longer updated, with fixes for the security problems
listed in [docs/CHANGES.md](docs/CHANGES.md). See [NOTICE.md](NOTICE.md) for
attribution and licenses.

## What you get

- **ID and relay servers** (`hbbs`, `hbbr`) for RustDesk clients.
- **Accounts and an admin panel** for users, devices, address books and
  connection logs.
- **Login enforcement** (`MUST_LOGIN=Y`): only a logged-in client can start a
  connection. Clients that are only ever connected *to* need no account.
- **Failed-login limits**: captcha on the panel and a temporary address ban.

## Quick start

You need a Linux server with Docker, a hostname pointing at it, and these
ports open: `21115-21119/tcp`, `21116/udp`, plus `80` and `443` for the
reverse proxy. Do not open `21114`.

```sh
git clone --recurse-submodules https://github.com/OWNER/rustdesk-backend.git
cd rustdesk-backend
cp .env.example .env                      # then edit .env
cp docker-compose.example.yml docker-compose.yml
docker compose up -d                      # or: docker compose up -d --build
```

Replace `OWNER` with the account that hosts your copy. To build the image
yourself instead of pulling it, change `image:` to `build: .` in
`docker-compose.yml`.

### Settings in `.env`

| Name | What to put there |
|---|---|
| `SERVER_HOST` | The hostname clients will use, for example `remote.example.com` |
| `JWT_KEY` | A random secret: `openssl rand -hex 32` |
| `TZ` | Your time zone, for example `America/New_York` |

### After the first start

1. **Admin password.** It is printed once in the logs:
   `docker compose logs | grep -i password`. Log in at
   `https://SERVER_HOST/_admin/` and change it.
2. **Public key.** Clients need it: `cat data/id_ed25519.pub`.
3. **Reverse proxy.** Copy [examples/nginx.conf](examples/nginx.conf), replace
   the hostname and add TLS.

### Client settings

In each RustDesk client (Settings → Network), or baked into a custom client:

| Field | Value |
|---|---|
| ID server | `SERVER_HOST` |
| Relay server | `SERVER_HOST` |
| API server | `https://SERVER_HOST` |
| Key | contents of `data/id_ed25519.pub` |

## Building

`docker build -t rustdesk-backend .` builds everything from source. The
included GitHub Actions workflow runs the tests and publishes the image to
`ghcr.io/OWNER/rustdesk-backend`.

## Layout

| Path | Contents |
|---|---|
| `server/` | ID and relay servers (Rust) |
| `api/` | API server (Go) |
| `web/` | Admin panel (Vue) |
| `examples/` | Reverse proxy example |
| `docs/CHANGES.md` | Every change from upstream, and known limits |

## License

`server/` is AGPL-3.0; `api/` and `web/` are MIT. See [NOTICE.md](NOTICE.md).
