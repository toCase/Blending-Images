# Blending Images
# ------------------------------------------
# Модель данных для работы с директориями
# ------------------------------------------

from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, Signal, Slot

from Database import Database

class DirModel(QAbstractListModel):

    data_list = []
    col1 = Qt.UserRole + 1
    col2 = Qt.UserRole + 2
    current = -1

    currentChanged = Signal(int, arguments = ['current'])
    error = Signal(str, arguments=['error'])

    def __init__(self, parent = None):
        super().__init__(parent)
        self.db = Database("dir")        
        self.loadModel()

    # ПЕРЕГРУЗКА ФУНКЦИИ МОДЕЛИ

    @Slot()
    def rowCount(self, parent = QModelIndex):
        return len(self.data_list)

    def data(self, index, role = Qt.DisplayRole):
        row = index.row()
        card = self.data_list[row]
        if index.isValid():
            if role == self.col1:
                return int(card.get('id'))
            if role == self.col2:
                return str(card.get('dir'))
        else:
            return str()

    def roleNames(self):
        return {
            self.col1: b"id",
            self.col2: b"dir",
        }

    # --------------------

    @Slot()
    def loadModel(self):
        '''
            получение данных из БД

            успех - загрузка модели
            нет - сигнал ошибки
        '''
        self.beginResetModel()
        self.data_list.clear()
        res = self.db.db_get(self.db.TABLE_DIRECTORY)
        if res.get('r'):
            self.data_list = res.get('data')
        else:
            self.error.emit(res.get('message'))
        self.endResetModel()

    @Slot(int, str, result=str)
    def get(self, i:int, n :str):
        '''
        получение элемента модели
        '''
        if i < self.rowCount() and self.rowCount() > 0:
            card = self.data_list[i]
            return str(card.get(n))
        return str()

    @Slot(str, result=bool)
    def save(self, dir: str):
        '''
        сохранение раздела, через лист
        - проверка заполнения
        - запрос на сохранение в БД
            успех - перезагрузка модели
            нет - сигнал ошибки
        '''
        id = self.current
        if len(dir) == 0:
            self.error.emit("Пустое название раздела!")
            return False
        else:
            d = { 'id':id, 'dir':dir}
            # res = self.db.directory_save(d)
            res = self.db.db_save(d, self.db.TABLE_DIRECTORY)
            if res.get('r'):
                self.current = res.get('id')
                self.loadModel()
                self.currentChanged.emit(self.current)
                return True
            else:
                self.error.emit(res.get('message'))
                return False

    @Slot(int, result=bool)
    def delete(self, count:int):
        '''
        удаление раздела, через идентификатор
        - запрос удаления из БД
            успех - перезагрузка модели
            нет - сигнал ошибки
        '''

        if count == 0:
            res = self.db.db_del(self.current, self.db.TABLE_DIRECTORY)
            if res.get('r'):
                self.loadModel()
            else:
                self.error.emit(res.get('message'))
            return res.get('r')
        else:
            self.error.emit("Нельзя удалить раздел, если в нем есть файлы")
            return False

    @Slot(int)
    def setCurrent(self, i: int):
        '''
            указание текущего элемента
            с сигналом изменения
            ??
        '''        

        self.beginResetModel()
        self.current = i
        self.currentChanged.emit(i)
        self.endResetModel()

    @Slot(result=int)
    def getCurrent(self):
        return self.current




