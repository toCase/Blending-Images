# -*- mode: python ; coding: utf-8 -*-

files = [
    ('qml/main.qml', './qml'),
    ('qml/Projects.qml', './qml'),
    ('qml/BaseFileSelector.qml', './qml'),
    ('qml/BaseEditor.qml', './qml'),
    ('qml/BaseDirSelector.qml', './qml'),
    ('qml/Base.qml', './qml'),
    ('qml/App.qml', './qml'),
    ('qml/ProjectMain.qml', './qml'),
    ('qml/ProjectCard.qml', './qml'),
    ('qml/ProjectConstructor.qml', './qml'),
    ('qml/ProjectPreview.qml', './qml'),
    ('qtquickcontrols2.conf', '.'),
]

a = Analysis(
    ['main.py'],
    pathex=[],
    binaries=[],
    datas=files,
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='BlendingImages',
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
    icon=['icon.ico'],
)
