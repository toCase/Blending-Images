# Blending Images
# ------------------------------------------
# Модель данных для работы с файлами
# ------------------------------------------
from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, Signal, Slot, QDir

from Database import Database
from misc import FileWorker


class FileModel(QAbstractListModel):

    error = Signal(str, arguments=['error'])

    def __init__(self, path, parent=None):
        super().__init__(parent)

        self.app_path = path

        self.data_list = []
        self.col1 = Qt.UserRole + 1
        self.col2 = Qt.UserRole + 2
        self.col3 = Qt.UserRole + 3
        self.col4 = Qt.UserRole + 4

        self.db = Database("files")
        self.worker = FileWorker("fm")

    @Slot(result=int)
    def rowCount(self, parent=QModelIndex):
        return len(self.data_list)

    def data(self, index, role=Qt.DisplayRole):
        row = index.row()
        card = self.data_list[row]
        if index.isValid():
            if role == self.col1:
                return card.get('id')
            if role == self.col2:
                return card.get('dir')
            if role == self.col3:
                return self.worker.getUrl(card.get('file'))
            if role == self.col4:
                return card.get('selected')
        else:
            return str()

    def roleNames(self):
        return {
            self.col1: b"id",
            self.col2: b"dir",
            self.col3: b"file",
            self.col4: b"selected",
        }

    #--------------------------

    @Slot()
    def loadModel(self):
        self.beginResetModel()
        self.data_list.clear()
        res = self.db.file_get(self.dir)
        if res.get('r'):
            self.data_list = res.get('data')
        else:
            self.error.emit(res.get('message'))

        self.selectedCount = 0
        self.endResetModel()

    @Slot(list, result=bool)
    def save(self, files: list):
        for file in files:

            fw = self.worker.saveFile(file)
            d = {'id':0, 'dir':self.dir, 'file':fw.get('file_path')}
            res = self.db.file_save(d)
            if res.get('r'):
                continue
            else:
                self.error.emit(res.get('message'))
                break
        self.loadModel()

    @Slot(int)
    def setCurrentDir(self, dir:int):
        self.dir = dir
        self.loadModel()

    @Slot(int, bool)
    def selectItem(self, index:int, selected:bool):
        self.beginResetModel()
        card = self.data_list[index]
        card['selected'] = selected
        self.data_list[index] = card
        if selected:
            self.selectedCount = self.selectedCount + 1
        else:
            self.selectedCount = self.selectedCount - 1
        self.endResetModel()

    @Slot()
    def selectAll(self):
        self.beginResetModel()
        i :int = 0
        for card in self.data_list:
            card['selected'] = True
            self.data_list[i] = card
            i = i + 1
        self.selectedCount = len(self.data_list)
        self.endResetModel()

    @Slot()
    def unselectAll(self):
        self.beginResetModel()
        i :int = 0
        for card in self.data_list:
            card['selected'] = False
            self.data_list[i] = card
            i = i + 1

        self.selectedCount = 0
        self.endResetModel()

    @Slot(result=int)
    def getSelectedCount(self):
        return self.selectedCount

    @Slot(int, result=bool)
    def changeDir(self, dir: int):
        if self.selectedCount > 0:
            for card in self.data_list:
                if card.get('selected'):
                    card['dir'] = dir
                    res = self.db.file_save(card)
                    if res.get('r'):
                        continue
                    else:
                        self.error.emit(res.get('message'))
                        return False
            self.loadModel()
        return True

    @Slot(result=bool)
    def delete(self):
        if self.selectedCount > 0:
            for card in self.data_list:
                if card.get('selected'):
                    self.worker.delFile(card.get('file'))
                    res = self.db.file_del(card.get('id'))
                    if res.get('r'):
                        continue
                    else:
                        self.error.emit(res.get('message'))
                        return False
            self.loadModel()
        return True




