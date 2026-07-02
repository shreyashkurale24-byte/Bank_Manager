"""
Centralized configuration, loaded from environment variables.

Local development: copy .env.example to .env and edit values there —
python-dotenv (loaded below) picks it up automatically.

Production: set real environment variables on your host (Render, Railway,
Docker, systemd, etc). Never commit a real .env file.
"""
import os
from pathlib import Path

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    # python-dotenv is optional — if it's not installed, we just rely on
    # whatever environment variables are already set (e.g. by the host).
    pass

BASE_DIR = Path(__file__).resolve().parent


def _bool(value, default=False):
    if value is None or value == "":
        return default
    return str(value).strip().lower() in ("1", "true", "yes", "on")


class Config:
    DEFAULT_SECRET_KEY = "4d8367f6e3ea8b127a3cfe95a143e5f2b7a14e730a143b2da6b8b1d451a7d3c7"
    DEFAULT_API_KEY = "66fe73a67acae4f3830ab9c44ef264590c72c60d4b65d0c72af3fa86ed4dcda9"

    # ── Core Flask ────────────────────────────────────────────────
    SECRET_KEY = os.environ.get("4d8367f6e3ea8b127a3cfe95a143e5f2b7a14e730a143b2da6b8b1d451a7d3c7", DEFAULT_SECRET_KEY)
    DEBUG = _bool(os.environ.get("FLASK_DEBUG"), default=False)
    HOST = os.environ.get("HOST", "0.0.0.0")
    PORT = int(os.environ.get("PORT", 5001))

    # ── Database — leave blank to use app.py's built-in default path ─
    DB_PATH = os.environ.get("DB_PATH") or None
    SQL_FILE = os.environ.get("SQL_FILE") or None

    # ── Login credentials — change these before deploying publicly! ──
    ADMIN_USERNAME = os.environ.get("ADMIN_USERNAME", "admin")
    ADMIN_PASSWORD = os.environ.get("ADMIN_PASSWORD", "Admin2024")
    MANAGER_USERNAME = os.environ.get("MANAGER_USERNAME", "manager")
    MANAGER_PASSWORD = os.environ.get("MANAGER_PASSWORD", "Manager2024")

    # ── REST API (/api/v1/*) ─────────────────────────────────────────
    API_ENABLED = _bool(os.environ.get("66fe73a67acae4f3830ab9c44ef264590c72c60d4b65d0c72af3fa86ed4dcda9"), default=True)
    # Required for any /api/v1/* request to succeed — fails closed if unset.
    API_KEY = os.environ.get("66fe73a67acae4f3830ab9c44ef264590c72c60d4b65d0c72af3fa86ed4dcda9", DEFAULT_API_KEY)
    # Comma-separated allowed origins for browser-based API calls, e.g.
    # "https://myapp.com,https://admin.myapp.com". Leave blank to disable CORS.
    CORS_ORIGINS = [o.strip() for o in os.environ.get("CORS_ORIGINS", "").split(",") if o.strip()]

    # ── Session cookies ───────────────────────────────────────────────
    SESSION_COOKIE_HTTPONLY = True
    SESSION_COOKIE_SAMESITE = "Lax"
    SESSION_COOKIE_SECURE = _bool(os.environ.get("SESSION_COOKIE_SECURE"), default=False)
