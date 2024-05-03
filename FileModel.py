# Blending Images
# ------------------------------------------
# Модель данных для работы с файлами
# ------------------------------------------
from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, Signal, Slot

from Database import Database
from misc import FileWorker


class FileModel(QAbstractListModel):

    error = Signal(str, arguments=['error'])

    def __init__(self, key:str, parent=None):
        super().__init__(parent)

        self.data_list = []
        self.col1 = Qt.UserRole + 1
        self.col2 = Qt.UserRole + 2
        self.col3 = Qt.UserRole + 3
        self.col4 = Qt.UserRole + 4
        self.col5 = Qt.UserRole + 5

        self.db = Database("files" + key)
        self.worker = FileWorker("fm" + key)
        self.filter_key = None

    #--перегрузка стандартных функций модели

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
            if role == self.col5:
                return card.get('project_count')
        else:
            return str()

    def roleNames(self):
        return {
            self.col1: b"id",
            self.col2: b"dir",
            self.col3: b"file",
            self.col4: b"selected",
            self.col5: b"count",
        }

    #--------------------------
    #--загрузка модели
    @Slot()
    def loadModel(self):
        self.beginResetModel()
        self.data_list.clear()
        res = self.db.db_get(self.db.TABLE_FILES, filter=self.dir, key=self.filter_key)
        if res.get('r'):
            self.data_list = res.get('data')
        else:
            self.error.emit(res.get('message'))

        self.selectedCount = 0
        self.endResetModel()

    #--сохранение
    @Slot(list, result=bool)
    def save(self, files: list):
        for file in files:

            fw = self.worker.saveFile(file)
            d = {'id':0, 'dir':self.dir, 'file':fw.get('file_path'), 'old':fw.get('old')}
            res = self.db.db_save(d, self.db.TABLE_FILES)
            if res.get('r'):
                continue
            else:
                self.error.emit(res.get('message'))
                break
        self.loadModel()

    #--определение текущего раздела
    @Slot(int)
    def setCurrentDir(self, dir:int):
        self.dir = dir
        self.loadModel()

    #--указываем какой елемент выбран
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

    #--выбираем все элементы
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

    #--снятия выбора элементов
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

    #--передает кол-во выбранных элементов
    @Slot(result=int)
    def getSelectedCount(self):
        return self.selectedCount

    #--перенос элемента в другой раздел
    @Slot(int, result=bool)
    def changeDir(self, dir: int):
        if self.selectedCount > 0:
            for card in self.data_list:
                if card.get('selected'):
                    card['dir'] = dir
                    res = self.db.db_save(card, self.db.TABLE_FILES)
                    if res.get('r'):
                        continue
                    else:
                        self.error.emit(res.get('message'))
                        return False
            self.loadModel()
        return True

    #--удаление елемента
    @Slot(result=bool)
    def delete(self):
        if self.selectedCount > 0:
            for card in self.data_list:
                if card.get('selected') and card.get('project_count') == 0:
                    self.worker.delFile(card.get('file'))
                    res = self.db.db_del(id=card.get('id'), table='Files')
                    if res.get('r'):
                        continue
                    else:
                        self.error.emit(res.get('message'))
                        return False
            self.loadModel()
        return True

    #--выбор только одного элемента в модели
    @Slot(int, bool, result=int)
    def selectItemOne(self, index:int, selected:bool):
        self.beginResetModel()

        i :int = 0
        for card in self.data_list:
            card['selected'] = False
            self.data_list[i] = card
            i = i + 1


        card = self.data_list[index]
        card['selected'] = selected
        self.data_list[index] = card

        self.endResetModel()

        if selected:
            return card['id']
        return 0

    #--устанавливаем текущий фильтр
    @Slot(str)
    def setFilterKey(self, key:str = None):
        self.filter_key = key
        self.loadModel()








