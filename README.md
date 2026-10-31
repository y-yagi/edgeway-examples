# edgeway-examples

Example apps for [Edgeway](https://github.com/y-yagi/edgeway).

- `todo-api/`: a JSON API on Cloudflare Workers + D1 (models, JWT auth, CORS, D1 Sessions). `todo-api/check.sh` checks a running instance.
  - `GET /todos` filters: `done=`, `ids=1,2,3` (IN), `q=text` (LIKE), `created_from=` / `created_to=` (ISO 8601 range), with `order=` and `dir=`.
  - `GET /todos/stats` counts done and open todos with raw SQL (`Model.select_all`).
  - `sessions: true` in `config/database.yml`: responses carry `X-D1-Bookmark`, which a client sends back to read its own writes.

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
