# Blending Images
# ------------------------------------------
# Модель данных для выбора граф файлов
# ------------------------------------------

from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, Slot, QDir, QUrl, QRegularExpression, QRegularExpressionMatch
from PySide6.QtGui import QImage

from Database import Database


class EmptyFileModel(QAbstractListModel):

    data_list = []

    col1 = Qt.UserRole + 1
    col2 = Qt.UserRole + 2
    col3 = Qt.UserRole + 3

    img_width: int = 76
    img_height: int = 85

    selectedCount: int = 0
    dir_path: str

    def __init__(self, parent = None):
        super().__init__(parent)
        self.db = Database('empty')

    @Slot()
    def rowCount(self, parent = QModelIndex):
        return len(self.data_list)

    def data(self, index, role = Qt.DisplayRole):
        row = index.row()
        card = self.data_list[row]
        if index.isValid():
            if role == self.col1:
                return card.get('file_name')
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
    def loadModel(self, path:str):
        self.beginResetModel()

        self.data_list.clear()

        self.dir_path = QUrl(path).path()
        file_dir = QDir(self.dir_path)
        filters = ["*.jpg",]
        file_list = file_dir.entryList(filters, QDir.Filter.Files)

        for file in file_list:
            file_name = QDir.toNativeSeparators(self.dir_path + "/" + file)
            img = QImage(file_name)
            if img.width() == self.img_width and img.height() == self.img_height:

                #тест на наличие файла в БД
                re = QRegularExpression("([^\\\/]+)\.[a-zA-Z0-9]+$")
                match = re.match(file_name)
                test = self.db.file_test(match.captured(0))

                card = {
                    'file_name':file_name,
                    'selected':False,
                    'saved':test,
                }

                self.data_list.append(card)
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
