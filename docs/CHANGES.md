# What this repository changes

The starting point is the upstream code listed in [NOTICE.md](../NOTICE.md).
Every change below is a separate commit you can read.

## Server (`server/`)

| Problem upstream | Change |
|---|---|
| `MUST_LOGIN` was checked only on punch-hole requests. A client could send a relay request directly and reach any peer without logging in. | Relay requests go through the same login check. |
| With `MUST_LOGIN=Y` and no JWT key, any non-empty token was accepted. | Every request is refused and an error is logged at startup. |
| A relay request was forwarded to the remote peer with the caller's access token still in it. | The token is removed before forwarding. |
| The JWT secret was printed to stdout when a token was generated. | Removed. |

## API (`api/`)

| Problem upstream | Change |
|---|---|
| `/api/admin/rustdesk/*` (server commands, including switching `MUST_LOGIN` off) needed a login but not admin rights. | Admin only. |
| All proxies were trusted by default, so a client could pick its own address with `X-Forwarded-For` and avoid the captcha and ban counters. | No proxy is trusted unless `trust-proxy` is set. |
| `/api/sysinfo` let anyone who knew a device ID overwrite that device's record (CVE-2026-111324). `/api/heartbeat` had the same gap. | A record is only updated by a request carrying the uuid the device registered with. |
| `/api/audit/conn` and `/api/audit/file` accepted entries from anyone. | Entries are only accepted from a registered device presenting its uuid. |
| `/api/shared-peer` crashed the request on a missing `share_token`. | Returns a normal error. |

## Known limits

- A new device ID can still be registered without a login. The stock client
  reports itself that way, so this cannot be closed on the server alone. Rate
  limit `/api/sysinfo` at your reverse proxy if this matters to you.
- The ID server checks a login token's signature and expiry but does not ask
  the API whether the user was disabled since. Keep
  `RUSTDESK_API_JWT_EXPIRE_DURATION` short if you remove users often.
- Login enforcement controls who may *start* a connection. The remote
  computer's own password or accept prompt is still what grants access.
