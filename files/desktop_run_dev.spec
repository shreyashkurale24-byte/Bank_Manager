# -*- mode: python ; coding: utf-8 -*-
#
# ============================================================================
#  BANK MANAGER PRO — INTERNAL DEV/TEST BUILD
#  PyInstaller spec file
#
#  This build is for internal development and testing ONLY.
#  - No authentication / access control has been verified in app.py
#  - No audit logging on writes/deletes
#  - Direct CRUD access to all 36 raw banking tables
#  DO NOT distribute this build to customers or production environments.
# ============================================================================

a = Analysis(
    ['desktop_run.py'],
    pathex=[],
    binaries=[],
    datas=[
        ('templates', 'templates'),
        ('Dumptables.sql', '.'),
    ],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='BankManagerPro_DEV',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon='assets\\icon.ico',
    version='version_info.txt',
)
