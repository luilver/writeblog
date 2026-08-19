# writeblog

A multi-blog publishing platform — a Rails 8.0 fork of
[Writebook](https://github.com/basecamp/writebook). Served by Puma + Thruster
on a [HOST_TYPE_REDACTED] [CONTAINER_REDACTED], exposed publicly at `https://blog.luilver.com` through a
[TUNNEL_GATEWAY_REDACTED], and protected by [AUTH_GATEWAY_REDACTED] ([AUTH_REDACTED]).

| | |
|---|---|
| Production URL | `https://blog.luilver.com` |
| [AUTH_REDACTED] | `[IDENTITY_REDACTED]`, `[IDENTITY_REDACTED]`, `[IDENTITY_REDACTED]`, `[IDENTITY_REDACTED]` only |
| CT | `writeblog` — [CONTAINER_REDACTED] **122**, `[LAN_IP_REDACTED]`, Ubuntu 24.04 |
| Stack | Ruby 3.3.1, Rails 8.0 alpha, SQLite, Redis, Puma + Thruster |
| LAN URL | `http://[LAN_IP_REDACTED]/` |

## Architecture

```
browser ──HTTPS──> Cloudflare edge ──Access([AUTH_REDACTED]) + tunnel──> cloudflared ([CONTAINER_REF_REDACTED])
                                                                │
                              ┌─────────────────────────────────┘
                              ▼
                    writeblog ([CONTAINER_REF_REDACTED] :3000)
                    ├─ Puma (via Thruster)
                    ├─ Redis (cache/cable/queue)
                    └─ Resque workers
```

## Setup (local development)

```bash
./bin/setup    # installs gems, prepares DBs
./bin/boot     # starts web, redis, workers via Procfile
```

## Build & deploy

```bash
# On [CONTAINER_REF_REDACTED]:
cd [APP_PATH_REDACTED]
git pull
bin/rails db:prepare RAILS_ENV=production
SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile

```

- **Provision the CT + systemd**: `docs/DEPLOYMENT.md`
- **[TUNNEL_GATEWAY_REDACTED] + Access**: `docs/CLOUDFLARE.md`

## Security notes

- The public hostname is gated by [AUTH_GATEWAY_REDACTED] ([AUTH_REDACTED]) for four
  identities only.
- The LAN IP `[LAN_IP_REDACTED]` is **not** behind Access; anyone on the home
  network can reach the app.
- `.env` / credentials are gitignored; never commit secrets.
