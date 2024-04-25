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
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

import DirModel
import FileModel
import EmptyFileModel
import ProjectModel

from misc import FileWorker

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # fw = FileWorker('x')

    dirModel = DirModel.DirModel(path = Path(__file__).resolve().parent)
    engine.rootContext().setContextProperty("modelDir", dirModel)

    fileModel = FileModel.FileModel(path = Path(__file__).resolve().parent)
    engine.rootContext().setContextProperty("modelFile", fileModel)

    emptyFileModel = EmptyFileModel.EmptyFileModel()
    engine.rootContext().setContextProperty("modelEmptyFile", emptyFileModel)

    projectModel = ProjectModel.ProjectModel()
    engine.rootContext().setContextProperty("modelProject", projectModel)

    qml_file = Path(__file__).resolve().parent / "qml/main.qml"
    engine.load(qml_file)
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
