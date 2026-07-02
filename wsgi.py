"""
WSGI entry point for production servers (gunicorn, uWSGI, Waitress, etc).

Example:
    gunicorn wsgi:app --bind 0.0.0.0:$PORT --workers 2
"""
from app import app, init_db

# Make sure tables exist before serving the first request.
init_db()

if __name__ == "__main__":
    app.run()
