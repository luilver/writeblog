# writeblog

A multi-blog publishing platform — a Rails 8.0 fork of
[Writebook](https://github.com/basecamp/writebook). Served by Puma + Thruster
at `https://blog.luilver.com`.

| | |
|---|---|
| Production URL | `https://blog.luilver.com` |
| Stack | Ruby 3.3.1, Rails 8.0 alpha, SQLite, Redis, Puma + Thruster |

## Architecture

```
browser ──HTTPS──> edge ──> web
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
git pull
bin/rails db:prepare RAILS_ENV=production
SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
```

## Security notes

- `.env` / credentials are gitignored; never commit secrets.
