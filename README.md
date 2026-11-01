# edgeway-examples

Example apps for [Edgeway](https://github.com/y-yagi/edgeway).

- `todo-api/`: a JSON API on Cloudflare Workers + D1 (models, JWT auth, CORS). A static file in `public/` (`robots.txt`) is served without the app. `POST /todos` also sends a "todo created" webhook (`APP_WEBHOOK_URL`) with the outbound HTTP client. `todo-api/check.sh` checks a running instance, starting a stub webhook receiver on port 8788.

These examples run against a checkout of Edgeway, not a released gem. Clone it **next to** this repository:

```
src/
  edgeway/            # https://github.com/y-yagi/edgeway
  edgeway-examples/   # this repository
```

`todo-api/Gemfile` uses `path: "../../edgeway"` (relative to `todo-api/`). To use a checkout elsewhere, set `EDGEWAY_PATH`:

```sh
cd todo-api
EDGEWAY_PATH=/path/to/edgeway bundle install
```
