import platform
from PySide6.QtCore import QObject, Slot, QUrl, QFile, QFileInfo, QDir
from PySide6.QtGui import QImage

from Database import Database

class FileWorker(QObject):

    def __init__(self, conn, parent=None):
        super().__init__(parent)

        self.app_dir = QDir(QDir.currentPath())

        app_dirs = self.app_dir.entryList(filters=QDir.Filter.Dirs)
        if "Base" not in app_dirs:
            self.app_dir.mkdir("Base")

        self.base_dir = QDir(QDir.toNativeSeparators(self.app_dir.path() + '/Base'))
        self.db = Database(conn)
        self.img_width = 76
        self.img_height = 85


    def saveFile(self, file_path:str):
        file_name = QFileInfo(file_path).fileName()
        new_path = QDir(QDir.toNativeSeparators(self.base_dir.path() + "/" + file_name))
        # if platform.system() == "Windows":
        #     new_path = QDir(QDir.toNativeSeparators(self.base_dir.path() + "\\" + file_name))
        r = QFile(file_path).copy(new_path.path())
        return {'r':r, 'file_path':new_path.path()}

    def delFile(self, file_path:str):
        r = QFile(file_path).remove()
        return r

    def getNameByPath(self, file_path: str):
        return QFileInfo(file_path).fileName()

    @Slot(str, result=QUrl)
    def getUrl(self, path: str):
        return QUrl().fromLocalFile(path)

    @Slot(result=str)
    def getPathByURL(self, folder_url: str):
        path = QUrl(folder_url).path()
        if platform.system() == "Windows":
            path = QUrl(folder_url).path()[1:]
        return QDir.toNativeSeparators(path)

    def getDataDir(self, folder_url: str):

        data_list = []

        dir_path = self.getPathByURL(folder_url)

        dir = QDir(dir_path)
        filters = ['*.jpg',]
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



