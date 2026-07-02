"""
REST JSON API — generic CRUD for every table detected from the SQL schema.

All routes live under /api/v1 and require a matching API key, sent as:
    X-API-Key: <your key>

The key is configured via the API_KEY environment variable. If it's not
set, every request fails closed with 503 rather than silently running
unauthenticated (this app manages banking data — better safe than sorry).

Endpoints
---------
GET    /api/v1/tables                        list all tables + row counts
GET    /api/v1/tables/<table>/schema         column definitions for a table
GET    /api/v1/tables/<table>                list rows (search, page, per_page)
POST   /api/v1/tables/<table>                create a row (JSON body)
GET    /api/v1/tables/<table>/<pk>           fetch a single row
PUT    /api/v1/tables/<table>/<pk>           update a row (JSON body)
DELETE /api/v1/tables/<table>/<pk>           delete a row

Composite primary keys are passed the same way the existing web UI does:
joined with "__", e.g. /api/v1/tables/somejoin/123__456
"""
from functools import wraps
from flask import Blueprint, jsonify, request, current_app

api_bp = Blueprint("api_v1", __name__, url_prefix="/api/v1")

# Populated by init_api() from app.py, to avoid a circular import between
# app.py (defines the DB helpers) and this module (uses them).
_fns = {}


def init_api(get_schema, get_cols, get_pk, get_rows, get_row,
             insert_row, update_row, delete_row, table_stats):
    _fns.update(dict(
        get_schema=get_schema, get_cols=get_cols, get_pk=get_pk,
        get_rows=get_rows, get_row=get_row, insert_row=insert_row,
        update_row=update_row, delete_row=delete_row, table_stats=table_stats,
    ))


def require_api_key(fn):
    @wraps(fn)
    def wrapper(*args, **kwargs):
        configured_key = current_app.config.get("API_KEY", "66fe73a67acae4f3830ab9c44ef264590c72c60d4b65d0c72af3fa86ed4dcda9")
        if not configured_key:
            return jsonify(error="The REST API is not configured. Set the API_KEY "
                                  "environment variable to enable it."), 503
        provided = request.headers.get("X-API-Key", "")
        if provided != configured_key:
            return jsonify(error="Invalid or missing API key. "
                                  "Send it as the X-API-Key header."), 401
        return fn(*args, **kwargs)
    return wrapper


@api_bp.route("/tables", methods=["GET"])
@require_api_key
def list_tables():
    schema = _fns["get_schema"]()
    stats = _fns["table_stats"]()
    return jsonify([
        {"name": name, "columns": len(defn["columns"]), "rows": stats.get(name, 0)}
        for name, defn in sorted(schema.items())
    ])


@api_bp.route("/tables/<table_name>/schema", methods=["GET"])
@require_api_key
def table_schema(table_name):
    schema = _fns["get_schema"]()
    if table_name not in schema:
        return jsonify(error=f"Unknown table '{table_name}'"), 404
    return jsonify(schema[table_name])


@api_bp.route("/tables/<table_name>", methods=["GET"])
@require_api_key
def list_rows(table_name):
    schema = _fns["get_schema"]()
    if table_name not in schema:
        return jsonify(error=f"Unknown table '{table_name}'"), 404
    search = request.args.get("search", "")
    try:
        page = max(1, int(request.args.get("page", 1)))
        per_page = min(200, max(1, int(request.args.get("per_page", 15))))
    except ValueError:
        return jsonify(error="page and per_page must be integers."), 400
    rows, total = _fns["get_rows"](table_name, search, page, per_page)
    return jsonify(data=rows, page=page, per_page=per_page, total=total)


@api_bp.route("/tables/<table_name>", methods=["POST"])
@require_api_key
def create_row(table_name):
    schema = _fns["get_schema"]()
    if table_name not in schema:
        return jsonify(error=f"Unknown table '{table_name}'"), 404
    payload = request.get_json(silent=True)
    if not isinstance(payload, dict):
        return jsonify(error="Request body must be a JSON object."), 400
    ok, msg = _fns["insert_row"](table_name, payload)
    return jsonify(success=ok, message=msg), (201 if ok else 400)


@api_bp.route("/tables/<table_name>/<path:pk_str>", methods=["GET"])
@require_api_key
def get_single_row(table_name, pk_str):
    schema = _fns["get_schema"]()
    if table_name not in schema:
        return jsonify(error=f"Unknown table '{table_name}'"), 404
    row = _fns["get_row"](table_name, pk_str.split("__"))
    if row is None:
        return jsonify(error="Record not found."), 404
    return jsonify(data=row)


@api_bp.route("/tables/<table_name>/<path:pk_str>", methods=["PUT", "PATCH"])
@require_api_key
def update_single_row(table_name, pk_str):
    schema = _fns["get_schema"]()
    if table_name not in schema:
        return jsonify(error=f"Unknown table '{table_name}'"), 404
    payload = request.get_json(silent=True)
    if not isinstance(payload, dict):
        return jsonify(error="Request body must be a JSON object."), 400
    ok, msg = _fns["update_row"](table_name, pk_str.split("__"), payload)
    return jsonify(success=ok, message=msg), (200 if ok else 400)


@api_bp.route("/tables/<table_name>/<path:pk_str>", methods=["DELETE"])
@require_api_key
def delete_single_row(table_name, pk_str):
    schema = _fns["get_schema"]()
    if table_name not in schema:
        return jsonify(error=f"Unknown table '{table_name}'"), 404
    ok, msg = _fns["delete_row"](table_name, pk_str.split("__"))
    return jsonify(success=ok, message=msg), (200 if ok else 400)


@api_bp.errorhandler(404)
def api_404(e):
    return jsonify(error="Not found."), 404
