# Blending Images
# ------------------------------------------
# Модель данных для работы с проектами
# ------------------------------------------
from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, Signal, Slot
# from PySide6.QtGui import QColor

from Database import Database


class ProjectModel(QAbstractListModel):

    error = Signal(str, arguments=['error'])

    def __init__(self, parent=None):
        super().__init__(parent)

        self.db = Database('prj')

        self.data_list = []

        self.col1 = Qt.UserRole + 1
        self.col2 = Qt.UserRole + 2
        self.col3 = Qt.UserRole + 3
        self.col4 = Qt.UserRole + 4
        self.col5 = Qt.UserRole + 5
        self.col6 = Qt.UserRole + 6
        self.col7 = Qt.UserRole + 7
        self.col8 = Qt.UserRole + 8
        self.col9 = Qt.UserRole + 9

        self.loadModel()

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
                return card.get('name')
            if role == self.col3:
                return card.get('width')
            if role == self.col4:
                return card.get('height')
            if role == self.col5:
                return card.get('rows')
            if role == self.col6:
                return card.get('columns')
            if role == self.col7:
                return card.get('file')
            if role == self.col8:
                return card.get('bg')
            if role == self.col9:
                return card.get('upd')
        return str()

    def roleNames(self):
        return {
            self.col1 : b"id",
            self.col2 : b"name",
            self.col3 : b"width",
            self.col4 : b"height",
            self.col5 : b"rows",
            self.col6 : b"columns",
            self.col7 : b"file",
            self.col8 : b"bg",
            self.col9 : b"upd",
        }

    #----------------------------

    @Slot()
    def loadModel(self):
        self.beginResetModel()
        self.data_list.clear()

        res = self.db.db_get(self.db.TABLE_PROJECT)
        if res.get('r'):
            self.data_list = res.get('data')
        else:
            self.error.emit(res.get('message'))

        self.endResetModel()

    # сохранение
    # цвет background передается как тип QColor, перед сохранением преобразовываем в HEX
    @Slot(dict, result=bool)
    def save(self, card :dict):
        bg = card['bg']
        card['bg'] = bg.name()
        res = self.db.db_save(card, self.db.TABLE_PROJECT)
        if res.get('r'):
            self.loadModel()
            return True
        else:
            self.error.emit(res.get('message'))
            return False

    @Slot(result=bool)
    def delete(self):
        res = self.db.db_del(self.currentID, self.db.TABLE_PROJECT)
        if res.get('r'):
            self.loadModel()
            return True
        else:
            self.error.emit(res.get('message'))
            return False

    @Slot(int)
    def setCurrent(self, i: int):
        self.currentID = self.data_list[i].get('id')
        print("ID: ", self.currentID)

    @Slot(int, str, result=str)
    def get(self, index:int, item:str):
        return str(self.data_list[index].get(item))


