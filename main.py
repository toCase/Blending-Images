# Blending Images
# version: 0.1
# ------------------------------------------
# Ev Shevchenko -- https://github.com/toCase
# @toCase
# 04.2024 Odesa Ukraine
# ------------------------------------------
# Сборка изображений в коллаж
# ------------------------------------------

import sys
import os
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from PySide6.QtQuickControls2 import QQuickStyle

import DirModel
import FileModel
import EmptyFileModel
import ProjectModel
import CollageModel

import rc_resource



if __name__ == "__main__":

    if not os.environ.get("QT_QUICK_CONTROLS_STYLE"):
        QQuickStyle.setStyle("Material")

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # fw = FileWorker('x')

    dirModel = DirModel.DirModel()
    engine.rootContext().setContextProperty("modelDir", dirModel)

    fileModel = FileModel.FileModel()
    engine.rootContext().setContextProperty("modelFile", fileModel)

    emptyFileModel = EmptyFileModel.EmptyFileModel()
    engine.rootContext().setContextProperty("modelEmptyFile", emptyFileModel)

    projectModel = ProjectModel.ProjectModel()
    engine.rootContext().setContextProperty("modelProject", projectModel)

    collageModel = CollageModel.CollageModel()
    engine.rootContext().setContextProperty("modelCollage", collageModel)

    qml_file = Path(__file__).resolve().parent / "qml/main.qml"
    engine.load(qml_file)
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
