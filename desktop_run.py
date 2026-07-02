import os
import sys
import threading
import time
from PyQt5.QtCore import QUrl
from PyQt5.QtWidgets import QApplication, QMainWindow
from PyQt5.QtWebEngineWidgets import QWebEngineView

# Force the application to execute out of its proper root folder
if getattr(sys, 'frozen', False):
    os.chdir(sys._MEIPASS)
else:
    os.chdir(os.path.dirname(os.path.abspath(__file__)))

from app import app, init_db

def run_backend():
    # Launches your Flask server quietly in the background
    app.run(host='127.0.0.1', port=5001, debug=False, use_reloader=False)

if __name__ == '__main__':
    # 1. Initialize your SQLite schema from Dumptables.sql automatically
    init_db()

    # 2. Run the server on a background thread
    bg_thread = threading.Thread(target=run_backend, daemon=True)
    bg_thread.start()

    # Give the backend server a fraction of a second to spin up safely
    time.sleep(0.5)

    # 3. Create a native PyQt Application window instance
    qapp = QApplication(sys.argv)
    
    window = QMainWindow()
    window.setWindowTitle("BANK Manager Pro")
    window.resize(1280, 800)

    # Embed Chromium browser straight into the application view frame layer
    browser = QWebEngineView()
    browser.setUrl(QUrl("http://127.0.0.1:5001/"))
    
    window.setCentralWidget(browser)
    window.show()

    sys.exit(qapp.exec_())