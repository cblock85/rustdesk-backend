# Attribution

This repository combines and modifies the following projects. All credit for
the original work belongs to their authors.

| Directory | Upstream | Commit | License |
|---|---|---|---|
| `server/` | [lejianwen/rustdesk-server](https://github.com/lejianwen/rustdesk-server), a fork of [rustdesk/rustdesk-server](https://github.com/rustdesk/rustdesk-server) | `fb8b5b9` | AGPL-3.0 |
| `server/libs/hbb_common` | [rustdesk/hbb_common](https://github.com/rustdesk/hbb_common) (git submodule) | `d6b1497` | AGPL-3.0 |
| `api/` | [lejianwen/rustdesk-api](https://github.com/lejianwen/rustdesk-api) | `c5687e1` | MIT |
| `web/` | [lejianwen/rustdesk-api-web](https://github.com/lejianwen/rustdesk-api-web) | `3998c2a` | MIT |

Each directory keeps its original `LICENSE` file. Changes made here are listed
in [docs/CHANGES.md](docs/CHANGES.md) and in the git history. The container
image built from this repository includes AGPL-3.0 code, so if you run a
modified version as a network service, the AGPL asks you to offer your source
to its users.

This project is not affiliated with or endorsed by RustDesk or by the upstream
authors. "RustDesk" is a trademark of its owner.
