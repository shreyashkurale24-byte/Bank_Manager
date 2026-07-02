"""
BANK MANAGER Pro — app.py
All 36 tables | Login + 5-min idle timeout | Full CRUD + REST API
"""
import sqlite3, re, os, json, sys
from flask import (Flask, render_template, request, redirect,
                   url_for, jsonify, flash, session)
from datetime import datetime

from config import Config
from api import api_bp, init_api

# ── DYNAMIC PATH RESOLUTION FOR EXECUTABLE BUNDLE ─────────────────────────
if getattr(sys, 'frozen', False):
    # If running inside the compiled .exe, look inside the temp folder (_MEIPASS)
    BASE_DIR = sys._MEIPASS
    template_dir = os.path.join(BASE_DIR, "templates")
    SQL_FILE = Config.SQL_FILE or os.path.join(BASE_DIR, "Dumptables.sql")

    # Store your working database in the user's computer Application Data folder
    # instead of the temp folder (so data isn't wiped out when closing the app!)
    DB_PATH = Config.DB_PATH or os.path.join(
        os.environ.get('APPDATA', os.path.expanduser('~')), "bank_manager_data.db")
else:
    # If running normally as code scripts
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
    template_dir = os.path.join(BASE_DIR, "templates")
    SQL_FILE = Config.SQL_FILE or os.path.join(BASE_DIR, "Dumptables.sql")
    DB_PATH = Config.DB_PATH or os.path.join(BASE_DIR, "data.db")

app = Flask(__name__, template_folder=template_dir)
app.config.from_object(Config)
app.secret_key = Config.SECRET_KEY

# Optional CORS support for the REST API — only enabled if CORS_ORIGINS is set
if Config.CORS_ORIGINS:
    from flask_cors import CORS
    CORS(app, resources={r"/api/*": {"origins": Config.CORS_ORIGINS}})

# ── Login credentials — override via env vars for real deployments ──────────
USERS = {
    Config.ADMIN_USERNAME: Config.ADMIN_PASSWORD,
    Config.MANAGER_USERNAME: Config.MANAGER_PASSWORD,
}

# ── Schema parsing ────────────────────────────────────────────────────────────
def parse_sql_schema(sql_content):
    tables = {}
    pattern = re.compile(r"CREATE TABLE `(\w+)`\s*\((.*?)\)\s*ENGINE", re.DOTALL|re.IGNORECASE)
    for match in pattern.finditer(sql_content):
        tname = match.group(1)
        body  = match.group(2)
        cols, pk_cols = [], []
        pk_m = re.search(r"PRIMARY KEY\s*\(([^)]+)\)", body)
        if pk_m:
            pk_cols = [c.strip().strip("`") for c in pk_m.group(1).split(",")]
        for line in body.split("\n"):
            line = line.strip().rstrip(",")
            if re.match(r"(PRIMARY|UNIQUE|KEY|INDEX)\b", line, re.IGNORECASE):
                continue
            cm = re.match(r"`(\w+)`\s+(\w+(?:\(\d+(?:,\d+)?\))?)", line)
            if cm:
                cname = cm.group(1)
                ctype = cm.group(2).upper()
                comment_m = re.search(r"COMMENT\s+'([^']*)'", line, re.IGNORECASE)
                comment   = comment_m.group(1) if comment_m else ""
                auto_inc  = "AUTO_INCREMENT" in line.upper()
                default_m = re.search(r"DEFAULT\s+'?([^',\s]+)'?", line, re.IGNORECASE)
                default   = default_m.group(1) if default_m and not auto_inc else None
                # Detect max length from varchar/char definitions
                len_m = re.search(r"\((\d+)\)", cm.group(2))
                max_len = int(len_m.group(1)) if len_m else None
                cols.append({
                    "name": cname, "type": ctype,
                    "nullable": "NOT NULL" not in line.upper(),
                    "auto_increment": auto_inc,
                    "is_pk": cname in pk_cols,
                    "comment": comment,
                    "default": default,
                    "max_len": max_len,
                })
        if cols:
            tables[tname] = {"columns": cols, "pk": pk_cols}
    return tables

def mysql_to_sqlite(t):
    t = t.upper()
    if any(x in t for x in ("INT","TINYINT","SMALLINT","BIGINT","BIT")): return "INTEGER"
    if any(x in t for x in ("DECIMAL","FLOAT","DOUBLE","NUMERIC")):      return "REAL"
    return "TEXT"

def build_ddl(tname, tdef):
    cols = []
    for c in tdef["columns"]:
        st = mysql_to_sqlite(c["type"])
        cd = f'"{c["name"]}" {st}'
        if c["is_pk"] and c["auto_increment"]:  cd += " PRIMARY KEY AUTOINCREMENT"
        elif c["is_pk"] and len(tdef["pk"])==1: cd += " PRIMARY KEY"
        if not c["nullable"] and not c["is_pk"]: cd += " NOT NULL"
        cols.append(cd)
    if len(tdef["pk"]) > 1:
        cols.append("PRIMARY KEY (" + ",".join(f'"{p}"' for p in tdef["pk"]) + ")")
    return f'CREATE TABLE IF NOT EXISTS "{tname}" (\n  ' + ",\n  ".join(cols) + "\n);"

SCHEMA_CACHE = {}
def get_schema():
    global SCHEMA_CACHE
    if not SCHEMA_CACHE and os.path.exists(SQL_FILE):
        with open(SQL_FILE,"r",encoding="utf-8",errors="replace") as f:
            SCHEMA_CACHE = parse_sql_schema(f.read())
    return SCHEMA_CACHE

def get_db():
    c = sqlite3.connect(DB_PATH)
    c.row_factory = sqlite3.Row
    return c

def init_db():
    schema = get_schema()
    c = get_db(); cur = c.cursor()
    for tname, tdef in schema.items():
        if len(tdef["pk"])>1:
            for col in tdef["columns"]:
                if col["auto_increment"] and col["name"] in tdef["pk"]:
                    col["auto_increment"] = False
        try: cur.execute(build_ddl(tname, tdef))
        except: pass
    c.commit(); c.close()

def get_cols(tname):   return get_schema().get(tname,{}).get("columns",[])
def get_pk(tname):     return get_schema().get(tname,{}).get("pk",["id"])

def get_rows(tname, search=None, page=1, per=15):
    cols = get_cols(tname)
    where, params = "", []
    if search and search.strip():
        tcols = [c["name"] for c in cols if "INT" not in c["type"] and "REAL" not in c["type"]][:5]
        if tcols:
            where  = "WHERE " + " OR ".join(f'"{x}" LIKE ?' for x in tcols)
            params = [f"%{search}%"]*len(tcols)
    c = get_db(); cur = c.cursor()
    try:
        total = cur.execute(f'SELECT COUNT(*) FROM "{tname}" {where}', params).fetchone()[0]
        off   = (page-1)*per
        rows  = [dict(r) for r in cur.execute(
            f'SELECT * FROM "{tname}" {where} LIMIT ? OFFSET ?', params+[per, off]).fetchall()]
    except: total, rows = 0, []
    c.close(); return rows, total

def get_row(tname, pk_vals):
    pk_cols = get_pk(tname)
    where   = " AND ".join(f'"{p}"=?' for p in pk_cols)
    c = get_db()
    try:
        r = c.execute(f'SELECT * FROM "{tname}" WHERE {where}', pk_vals).fetchone()
        return dict(r) if r else None
    except: return None
    finally: c.close()

def insert_row(tname, data):
    cols = get_cols(tname)
    wr   = {c["name"]: data[c["name"]] for c in cols if not c["auto_increment"] and c["name"] in data}
    col_list = ", ".join(f'"{k}"' for k in wr)
    ph_list  = ", ".join("?" for _ in wr)
    sql  = f'INSERT INTO "{tname}" ({col_list}) VALUES ({ph_list})'
    c = get_db()
    try: c.execute(sql, list(wr.values())); c.commit(); return True,"Record inserted successfully! ✓"
    except Exception as e: return False, str(e)
    finally: c.close()

def update_row(tname, pk_vals, data):
    pk_cols  = get_pk(tname)
    cols     = get_cols(tname)
    wr       = {c["name"]: data.get(c["name"],"") for c in cols if not c["auto_increment"] and c["name"] not in pk_cols}
    if not wr: return False,"Nothing to update"
    set_cl   = ",".join(f'"{k}"=?' for k in wr)
    where    = " AND ".join(f'"{p}"=?' for p in pk_cols)
    c = get_db()
    try: c.execute(f'UPDATE "{tname}" SET {set_cl} WHERE {where}', list(wr.values())+list(pk_vals)); c.commit(); return True,"Record updated successfully! ✓"
    except Exception as e: return False, str(e)
    finally: c.close()

def delete_row(tname, pk_vals):
    pk_cols = get_pk(tname)
    # Sanitise pk values — strip surrounding whitespace
    pk_vals = [str(v).strip() for v in pk_vals]
    if len(pk_vals) != len(pk_cols):
        return False, f"PK mismatch: expected {len(pk_cols)} key(s), got {len(pk_vals)}"
    where   = " AND ".join(f'"{p}"=?' for p in pk_cols)
    c = get_db()
    try:
        cur = c.execute(f'DELETE FROM "{tname}" WHERE {where}', pk_vals)
        c.commit()
        if cur.rowcount == 0:
            return False, "No matching record found — it may have already been deleted."
        return True, f"Record deleted successfully. ✓"
    except Exception as e:
        return False, str(e)
    finally:
        c.close()

def table_stats():
    schema = get_schema(); c = get_db(); cur = c.cursor(); stats={}
    for t in schema:
        try: stats[t] = cur.execute(f'SELECT COUNT(*) FROM "{t}"').fetchone()[0]
        except: stats[t] = 0
    c.close(); return stats

# ── Wire the REST API blueprint to the table helpers above ──────────────────
init_api(get_schema, get_cols, get_pk, get_rows, get_row,
         insert_row, update_row, delete_row, table_stats)
if Config.API_ENABLED:
    app.register_blueprint(api_bp)

# ── Auth helpers ──────────────────────────────────────────────────────────────
def logged_in():  return session.get("user") is not None
def require_auth():
    if not logged_in():
        session["next"] = request.url
        return redirect(url_for("login"))
    return None

# ── Routes ────────────────────────────────────────────────────────────────────
@app.route("/login", methods=["GET","POST"])
def login():
    if logged_in(): return redirect(url_for("index"))
    error = None
    if request.method == "POST":
        u = request.form.get("username","").strip()
        p = request.form.get("password","")
        if USERS.get(u) == p:
            session.clear()
            session["user"] = u
            session.permanent = False
            nxt = session.pop("next", None)
            return redirect(nxt or url_for("index"))
        error = "Invalid username or password."
    return render_template("login.html", error=error)

@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))

@app.route("/")
def index():
    r = require_auth()
    if r: return r
    schema = get_schema(); stats = table_stats()
    tables_info = sorted([{"name":n,"cols":len(d["columns"]),"rows":stats.get(n,0)} for n,d in schema.items()], key=lambda x:x["name"])
    return render_template("index.html", tables=tables_info, total_tables=len(schema), total_records=sum(stats.values()))

@app.route("/table/<table_name>")
def table_view(table_name):
    r = require_auth()
    if r: return r
    schema = get_schema()
    if table_name not in schema: flash("Table not found","error"); return redirect(url_for("index"))
    search   = request.args.get("search","")
    page     = int(request.args.get("page",1))
    rows, total = get_rows(table_name, search, page)
    total_pages = max(1,(total+14)//15)
    return render_template("table.html", table_name=table_name,
        columns=get_cols(table_name), rows=rows, pk_cols=get_pk(table_name),
        search=search, page=page, total_pages=total_pages, total=total,
        tables=sorted(schema.keys()))

@app.route("/table/<table_name>/new", methods=["GET","POST"])
def row_new(table_name):
    r = require_auth()
    if r: return r
    schema = get_schema()
    cols = get_cols(table_name)
    if request.method == "POST":
        ok, msg = insert_row(table_name, dict(request.form))
        flash(msg,"success" if ok else "error")
        if ok: return redirect(url_for("table_view", table_name=table_name))
    return render_template("form.html", table_name=table_name, columns=cols,
        row=None, mode="Create", tables=sorted(schema.keys()))

@app.route("/table/<table_name>/edit/<path:pk_str>", methods=["GET","POST"])
def row_edit(table_name, pk_str):
    r = require_auth()
    if r: return r
    schema = get_schema()
    cols    = get_cols(table_name)
    pk_vals = pk_str.split("__")
    row     = get_row(table_name, pk_vals)
    if request.method == "POST":
        ok, msg = update_row(table_name, pk_vals, dict(request.form))
        flash(msg,"success" if ok else "error")
        if ok: return redirect(url_for("table_view", table_name=table_name))
    return render_template("form.html", table_name=table_name, columns=cols,
        row=row, mode="Edit", tables=sorted(schema.keys()))

@app.route("/table/<table_name>/delete/<path:pk_str>", methods=["POST"])
def row_delete(table_name, pk_str):
    r = require_auth()
    if r: return r
    ok, msg = delete_row(table_name, pk_str.split("__"))
    flash(msg,"success" if ok else "error")
    return redirect(url_for("table_view", table_name=table_name))

@app.route("/settings")
def settings_page():
    r = require_auth()
    if r: return r
    schema = get_schema()
    return render_template("settings.html", tables=sorted(schema.keys()))

@app.route("/healthz")
def healthz():
    """Lightweight health check for hosting platforms (Render, Railway, etc)."""
    return jsonify(status="ok"), 200

@app.route("/api/stats")
def api_stats():
    if not logged_in(): return jsonify({}), 401
    return jsonify(table_stats())

if __name__ == "__main__":
    init_db()
    print("\n══════════════════════════════════════════")
    print("  🏦  BANK MANAGER PRO")
    print(f"  ✅  DB ready  |  http://{Config.HOST}:{Config.PORT}")
    print(f"  👤  {Config.ADMIN_USERNAME} / {'*' * len(Config.ADMIN_PASSWORD)}")
    if Config.API_ENABLED:
        api_state = "enabled" if Config.API_KEY else "enabled but UNPROTECTED (set API_KEY!)"
        print(f"  🔌  REST API  |  /api/v1/*  ({api_state})")
    else:
        print("  🔌  REST API  |  disabled (set API_ENABLED=true to turn on)")
    if Config.SECRET_KEY == Config.DEFAULT_SECRET_KEY:
        print("  ⚠️   Using the default SECRET_KEY — set a real one in .env before deploying!")
    print("══════════════════════════════════════════\n")
    app.run(debug=Config.DEBUG, host=Config.HOST, port=Config.PORT)
