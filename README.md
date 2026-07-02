# 🗄 Bank Manager Pro — Full CRUD UI + REST API for 36 Tables

A Flask web application for managing your banking database, with a web UI for humans and a REST JSON API for everything else.

## Features
- ✅ **All 36 tables** auto-detected from your SQL dump
- ✅ **Web UI**: Create / Read / Update / Delete, search, pagination, schema browser
- ✅ **REST API** (`/api/v1/*`): full CRUD over JSON, API-key protected
- ✅ **Settings page**: dark/light mode, accent colour, links to the API & companion dashboard
- ✅ **Environment-based config**: secrets, credentials, and API keys all come from environment variables — nothing sensitive is hardcoded
- ✅ Ready to deploy: `wsgi.py`, `Procfile`, `Dockerfile` included

---

## 1. Local Setup

```bash
pip install -r requirements.txt
cp .env.example .env
```

Edit `.env` — at minimum, set a real `SECRET_KEY` and, if you want the API enabled, an `API_KEY`:

```bash
python3 -c "import secrets; print(secrets.token_hex(32))"   # run twice, once per key
```

Run it:
```bash
python3 run.py
```
Open **http://127.0.0.1:5000** — login with the `ADMIN_USERNAME` / `ADMIN_PASSWORD` from your `.env` (defaults: `admin` / `admin123` — **change these before deploying publicly**).

---

## 2. Environment Variables

All configuration lives in `config.py`, populated from environment variables (see `.env.example` for the full list with descriptions):

| Variable | Purpose | Default |
|---|---|---|
| `SECRET_KEY` | Flask session signing key | insecure dev default — **must** override in production |
| `FLASK_DEBUG` | Enable Flask debug mode | `false` |
| `HOST` / `PORT` | Bind address | `0.0.0.0` / `5000` |
| `DB_PATH` / `SQL_FILE` | Override the default SQLite/schema file locations | auto-detected |
| `ADMIN_USERNAME` / `ADMIN_PASSWORD` | Primary login | `admin` / `admin123` |
| `MANAGER_USERNAME` / `MANAGER_PASSWORD` | Secondary login | `manager` / `bank2024` |
| `API_ENABLED` | Turn the REST API on/off | `true` |
| `API_KEY` | Required for any `/api/v1/*` request. **Blank = API refuses all requests (503)**, it does not fall open. | *(blank)* |
| `CORS_ORIGINS` | Comma-separated allowed origins for browser API calls | *(blank = no CORS)* |
| `SESSION_COOKIE_SECURE` | Set `true` once served over HTTPS | `false` |

---

## 3. REST API

Every table is exposed as JSON under `/api/v1/`, authenticated with an `X-API-Key` header matching your configured `API_KEY`.

| Method | Path | Description |
|---|---|---|
| GET | `/api/v1/tables` | List all tables with row counts |
| GET | `/api/v1/tables/<table>/schema` | Column definitions for a table |
| GET | `/api/v1/tables/<table>?search=&page=&per_page=` | List rows (paginated, optional search) |
| POST | `/api/v1/tables/<table>` | Create a row — JSON body |
| GET | `/api/v1/tables/<table>/<pk>` | Fetch a single row |
| PUT | `/api/v1/tables/<table>/<pk>` | Update a row — JSON body |
| DELETE | `/api/v1/tables/<table>/<pk>` | Delete a row |

Composite primary keys are joined with `__`, e.g. `/api/v1/tables/somejoin/123__456`.

Example:
```bash
curl http://localhost:5000/api/v1/tables \
  -H "X-API-Key: your-api-key"

curl -X POST http://localhost:5000/api/v1/tables/goldrate \
  -H "X-API-Key: your-api-key" -H "Content-Type: application/json" \
  -d '{"rate": "6250.00", "effective_date": "2026-07-02"}'
```

---

## 4. Deployment

### Option A — Docker (any host)
```bash
docker build -t bank-manager-pro .
docker run -p 5000:5000 --env-file .env bank-manager-pro
```

### Option B — Render / Railway / Heroku-style platforms
1. Push this project to a git repo.
2. Create a new Web Service pointing at it — they'll auto-detect `Procfile` / `requirements.txt`.
3. Set the environment variables from `.env.example` in the platform's dashboard (never commit `.env`).
4. Deploy. The platform sets `$PORT` automatically; `Procfile` already uses it.

### Option C — Your own VPS (Gunicorn + Nginx)
```bash
pip install -r requirements.txt
gunicorn wsgi:app --bind 0.0.0.0:5000 --workers 3
```
Put Nginx in front as a reverse proxy and terminate TLS there, then set `SESSION_COOKIE_SECURE=true`.

### Health check
`GET /healthz` returns `{"status": "ok"}` — point your host's health check at it.

---

## 5. Companion App: API & DB Dashboard

A separate Node/React project (`bank-manager-pro-api-_-db-dashboard`) ships alongside this one — a schema browser, SQL playground, and API console. It runs independently on its own port (default `:3000`) against its own sample data, and links back to this app from its header. See that project's own README for setup.

---

## File Structure

```
bank_pro_v8/
├── app.py             ← Main Flask application (routes, web UI, DB helpers)
├── config.py          ← Environment-driven configuration
├── api.py             ← REST API blueprint (/api/v1/*)
├── wsgi.py            ← Production entry point (gunicorn wsgi:app)
├── run.py             ← Dev entry point
├── requirements.txt
├── .env.example       ← Copy to .env and fill in
├── .gitignore
├── Procfile           ← Heroku/Render-style platforms
├── Dockerfile
├── Dumptables.sql     ← Table schema source
├── data.db            ← SQLite database (auto-created)
├── README.md
└── templates/
    ├── base.html       ← Sidebar + layout + theme engine
    ├── index.html      ← Dashboard
    ├── settings.html   ← Settings page (theme + API info)
    ├── table.html      ← Table view with grid
    ├── form.html       ← Create / Edit form
    └── login.html
```

---

## Connecting to a Real MySQL Database

To connect to a live MySQL database instead of SQLite:

1. `pip install pymysql`
2. In `app.py`, replace `get_db()`:
   ```python
   import pymysql

   def get_db():
       return pymysql.connect(
           host="127.0.0.1", user="root", password="your_password",
           database="testdata", cursorclass=pymysql.cursors.DictCursor
       )
   ```
