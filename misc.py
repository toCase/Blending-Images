# Blending Images
# ------------------------------------------
# Работа с файлам - работает в Windows и Linux
# ------------------------------------------
import platform
from PySide6.QtCore import QObject, Slot, QUrl, QFile, QFileInfo, QDir, QDateTime, QIODevice, QJsonDocument
from PySide6.QtGui import QImage

from Database import Database

class FileWorker(QObject):

    def __init__(self, conn, parent=None):
        super().__init__(parent)

        self.app_dir = QDir(QDir.currentPath())

        app_dirs = self.app_dir.entryList(filters=QDir.Filter.Dirs)
        if "Base" not in app_dirs:
            self.app_dir.mkdir("Base")

        app_files = self.app_dir.entryList(filters=QDir.Filter.Files)
        if "setting.json" not in app_files:
            self.makeJsonSetting()


        self.base_dir = QDir(QDir.toNativeSeparators(self.app_dir.path() + '/Base'))
        self.db = Database(conn)
        self.img_width = 76
        self.img_height = 85

    # -- сохранение файлов
    def saveFile(self, file_path:str):
        old = QFileInfo(file_path).fileName()
        file_name = str(QDateTime.currentMSecsSinceEpoch()) + ".jpg"
        new_path = QDir(QDir.toNativeSeparators(self.base_dir.path() + "/" + file_name))
        r = QFile(file_path).copy(new_path.path())
        return {'r':r, 'file_path':new_path.path(), 'old':old}

    # -- удаление файлов
    def delFile(self, file_path:str):
        r = QFile(file_path).remove()
        return r

    # -- получение имени файла из пути
    def getNameByPath(self, file_path: str):
        return QFileInfo(file_path).fileName()

    # -- получить URL пути
    @Slot(str, result=QUrl)
    def getUrl(self, path: str):
        return QUrl().fromLocalFile(path)

    # -- получить путь по URL
    @Slot(result=str)
    def getPathByURL(self, folder_url: str):
        path = QUrl(folder_url).path()
        if platform.system() == "Windows":
            path = QUrl(folder_url).path()[1:]
        return QDir.toNativeSeparators(path)

    # --получить данные папки
    def getDataDir(self, folder_url: str, file_filter: str = None):

        data_list = []

        dir_path = self.getPathByURL(folder_url)

        dir = QDir(dir_path)
        filters = ['*.jpg',]
        if file_filter:
            filters = [f'*{file_filter}*.jpg',]

        files = dir.entryList(filters, QDir.Filter.Files)

        for file in files:
            file_name = QDir.toNativeSeparators(dir_path + '/' + file)
            if platform.system() == "Windows":
                file_name = QDir.toNativeSeparators(dir_path + '\\' + file)
            img = QImage(file_name)
            if img.width() == self.img_width and img.height() == self.img_height:

                test = self.db.file_test(file)

                card = {
                    'file_name':file_name,
                    'selected':False,
                    'saved':test,
                }

                data_list.append(card)
        return data_list

    # -- удаление временного файла
    def removeTempFile(self):
        self.app_dir = QDir(QDir.currentPath())
        app_files = self.app_dir.entryList(filters=QDir.Filter.Files)
        print("AF: ", app_files)
        if "temp" in app_files:
            print("DEL TEMP")
            file = QFile("temp")
            file.remove()


    # -- получение данных из файла настройки
    def getJsonSetting(self):
        file = QFile("setting.json")
        sett = {}
        if file.open(QIODevice.OpenModeFlag.ReadOnly):
            dataString = file.readAll();

            doc = QJsonDocument.fromJson(dataString);
            file.close()
            dataobject = doc.object();

            sett = {
            "intend":dataobject["intend"]
            }

        return  sett

    # -- сохранение в файл настройки
    def setJsonSetting(self, d:dict):
        file = QFile("setting.json")
        if file.open(QIODevice.OpenModeFlag.ReadOnly):
            dataString = file.readAll();

            doc = QJsonDocument.fromJson(dataString);
            file.close()

            dataobject = doc.object();
            dataobject["intend"] = d["intend"]
            doc.setObject(dataobject)
            print("M")

        if file.open(QIODevice.OpenModeFlag.WriteOnly | QFile.OpenModeFlag.Text | QFile.OpenModeFlag.Truncate):
            file.write(doc.toJson())
            file.close()

    # -- установление первоначальных настроек
    def makeJsonSetting(self):
        file = QFile("setting.json")
        doc = QJsonDocument()
        obj = doc.object()
        obj['intend'] = 10
        doc.setObject(obj)

        if file.open(QIODevice.OpenModeFlag.WriteOnly | QFile.OpenModeFlag.Text | QFile.OpenModeFlag.Truncate):
            file.write(doc.toJson())
            file.close()

    # -- удаление файлов превью
    def removePreview(self):
        filters = ['preview*',]
        app_files = self.app_dir.entryList(filters, QDir.Filter.Files)
        for file in app_files:
            f = QFile(file)
            f.remove()

    # --???
    def getAppDir(self):
        return self.app_dir










