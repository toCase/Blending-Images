# Blending Images
# ------------------------------------------
# Модель данных для выбора граф файлов
# ------------------------------------------

from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, Slot
from misc import FileWorker

class EmptyFileModel(QAbstractListModel):

    data_list = []

    col1 = Qt.UserRole + 1
    col2 = Qt.UserRole + 2
    col3 = Qt.UserRole + 3
    selectedCount: int = 0
    dir_path: str

    def __init__(self, parent = None):
        super().__init__(parent)
        self.worker = FileWorker('efm')
        self.folder = None
        self.dir_path = None

    @Slot()
    def rowCount(self, parent = QModelIndex):
        return len(self.data_list)

    def data(self, index, role = Qt.DisplayRole):
        row = index.row()
        card = self.data_list[row]
        if index.isValid():
            if role == self.col1:
                return self.worker.getUrl(card.get('file_name'))
            if role == self.col2:
                return card.get('selected')
            if role == self.col3:
                return card.get('saved')

        else:
            return str()

    def roleNames(self):
        return {
            self.col1: b"file_name",
            self.col2: b"selected",
            self.col3: b"saved",
        }

    @Slot(str)
    def setFolderUrl(self, folder: str):
        self.folder = folder

    @Slot()
    def loadModel(self):
        self.beginResetModel()
        self.data_list.clear()
        if self.folder:
            self.dir_path = self.worker.getPathByURL(self.folder)
            self.data_list = self.worker.getDataDir(self.folder)
        self.selectedCount = 0
        self.endResetModel()


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

    @Slot(result=str)
    def getFolderName(self):
        return self.dir_path

    @Slot(result=list)
    def getSelectedList(self):
        l = []
        if len(self.data_list) > 0:
            for card in self.data_list:
                if card['selected']:
                    l.append(card['file_name'])
        return l
