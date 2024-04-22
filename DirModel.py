# Blending Images
# ------------------------------------------
# Модель данных для работы с директориями
# ------------------------------------------

from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, Signal, Slot, QDir

from Database import Database

class DirModel(QAbstractListModel):

    data_list = []
    col1 = Qt.UserRole + 1
    col2 = Qt.UserRole + 2
    current = -1

    currentChanged = Signal(int, arguments = ['current'])
    error = Signal(str, arguments=['error'])

    def __init__(self, path, parent = None):
        super().__init__(parent)
        self.app_path = path

        app_dir = QDir(str(self.app_path))
        app_dirs = app_dir.entryList(filters=QDir.Filter.Dirs)
        if "Base" not in app_dirs:
            app_dir.mkdir("Base")
        self.base_dir = QDir(QDir.toNativeSeparators(str(self.app_path) + "/Base"))
        # self.data_list = base_dir.entryList(filters=QDir.Filter.Dirs | QDir.Filter.NoDotAndDotDot)

        self.db = Database("dir")
        self.loadModel()

    # ПЕРЕГРУЗКА ФУНКЦИИ МОДЕЛИ

    def rowCount(self, parent = QModelIndex):
        return len(self.data_list)

    def data(self, index, role = Qt.DisplayRole):
        row = index.row()
        card = self.data_list[row]
        if index.isValid():
            if role == self.col1:
                return card.get('id')
            if role == self.col2:
                return card.get('dir')
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
        data = self.db.directory_get()
        if data.get('r'):
            self.data_list = data.get('data')
        else:
            self.error.emit(data.get('message'))
        self.endResetModel()

    @Slot(int, str, result=str)
    def get(self, i:int, n :str):
        '''
        получение элемента модели
        '''
        card = self.data_list[i]
        return str(card.get(n))

    @Slot(list, result=bool)
    def save(self, l: list):
        '''
        сохранение раздела, через лист
        - проверка заполнения
        - запрос на сохранение в БД
            успех - перезагрузка модели
            нет - сигнал ошибки
        '''
        id = l[0]
        dir = l[1]
        if len(dir) == 0:
            self.error.emit("Пустое название раздела!")
            return False
        else:
            d = { 'id':l[0], 'dir':l[1]}
            data = self.db.directory_save(d)
            if data.get('r'):
                self.loadModel()
                return True
            else:
                self.error.emit(data.get('message'))
                return False

    @Slot(int, result=bool)
    def delete(self, i: int):
        '''
        удаление раздела, через идентификатор
        - запрос удаления из БД
            успех - перезагрузка модели
            нет - сигнал ошибки
        '''
        data = self.db.directory_del(i)
        if data.get('r'):
            self.loadModel()
            return True
        else:
            self.error.emit(data.get('message'))
            return False

    @Slot(int)
    def setCurrent(self, i: int):
        '''
            указание текущего элемента
            с сигналом изменения
            ??
        '''
        self.current = i
        self.currentChanged.emit(i)




