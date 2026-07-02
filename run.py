#!/usr/bin/env python3
"""
BANK Manager - Startup Script
Run this file to launch the application.

Usage:
    python3 run.py

Then open: http://127.0.0.1:5000
"""

import os
import sys

# Make sure we're in the right directory
os.chdir(os.path.dirname(os.path.abspath(__file__)))

# Check Flask is installed
try:
    import flask
except ImportError:
    print("❌ Flask not found. Install it:")
    print("   pip install flask")
    sys.exit(1)

from app import app, init_db
from config import Config

print("=" * 55)
print("  🗄  BANK Manager — MySQL Schema CRUD Interface")
print("=" * 55)
print()
print("  📋 Loading schema from Dumptables.sql …")

init_db()

print("  ✅ Database initialized (SQLite backend)")
print()
print(f"  🚀 Server starting at: http://127.0.0.1:5001")
print()
print("  Press Ctrl+C to stop")
print("=" * 55)

app.run(debug=Config.DEBUG, host=Config.HOST, port=Config.PORT)
