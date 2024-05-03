# Blending Images
# ------------------------------------------
# Модель данных для работы с проектами
# ------------------------------------------
from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, Signal, Slot, QPoint, QDir, QUrl
from PySide6.QtGui import QPainter, QColor, QImage
from Database import Database
from misc import FileWorker

class ProjectModel(QAbstractListModel):

    error = Signal(str, arguments=['error'])
    imgReady = Signal(QUrl, arguments=['file'])

    def __init__(self, parent=None):
        super().__init__(parent)

        self.db = Database('prj')
        self.fw = FileWorker("PMFW")

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

        self.filter = None

        self.loadModel()

    # -- перегрузка стандартных функций

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

        res = self.db.db_get(self.db.TABLE_PROJECT, self.filter)
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

        # for item's generator
        rows = int(card['rows'])
        columns = int(card['columns'])

        if card['id'] > 0:
            self.db.db_del(0, self.db.TABLE_ITEMS, filter=card['id'])

        #-------

        card['bg'] = bg.name()
        res = self.db.db_save(card, self.db.TABLE_PROJECT)
        if res.get('r'):
            self.loadModel()            
            project_id = int(res.get('id'))

            # ITEMS GENERATION
            for r in range(0, rows, 1):
                for c in range(0, columns, 1):
                    d = {
                        'id': 0,
                        'project':project_id,
                        'row':r,
                        'col':c,
                        'file':0
                    }
                    self.db.db_save(d, self.db.TABLE_ITEMS)
            #------

            return True
        else:
            self.error.emit(res.get('message'))
            return False

    # --удаление элементов
    @Slot(result=bool)
    def delete(self):
        res = self.db.db_del(self.currentID, self.db.TABLE_PROJECT)
        if res.get('r'):
            self.db.db_del(0, self.db.TABLE_ITEMS, self.currentID)
            self.loadModel()
            return True
        else:
            self.error.emit(res.get('message'))
            return False

    # -- опреление текущего элемента
    @Slot(int)
    def setCurrent(self, i: int):
        self.currentID = self.data_list[i].get('id')
        self.currentCard = self.data_list[i]
        self.makeImage()

    # -- получить элемент по индексу и названию
    @Slot(int, str, result=str)
    def get(self, index:int, item:str):
        return str(self.data_list[index].get(item))

    # -- установить фильтр
    @Slot(str)
    def setFilter(self, f:str):
        self.filter = f
        self.loadModel()

    # -- создать превью
    def makeImage(self):
        self.fw.removePreview()
        card = self.currentCard
        map_items = []
        x = self.db.db_get(self.db.TABLE_ITEMS, card.get('id'))
        if x['r']:
            _data = x['data']

            for r in range (0, card.get('rows'), 1):
                _row = {}
                for item in _data:
                    if item['row'] == r:
                        _id = item['id']
                        _file = item['file']
                        if _file == 0:
                            _type = False
                            _display = card.get('bg')
                        else:
                           _type = True
                           _display = self.fw.getUrl(self.db.getFile(_file))

                        _row[item['col']] = {'id':_id, 'file':_file, 'displayType':_type, 'display': _display, 'selected': False}
                map_items.append(_row)

        # Создание изображения размером, соответствующим вашему проекту
        image = QImage(card.get('columns') * 76, card.get('rows') * 85, QImage.Format_RGB32)
        image.fill(QColor(card.get('bg')))  # Заливка фона цветом проекта

        painter = QPainter(image)
        for r in range(0, card.get('rows')):
            data_row = map_items[r]

            for c in range(0, card.get('columns')):

                card_item = data_row.get(c)
                x = c * 76
                y = r * 85

                if card_item['displayType']:
                    img = QImage()
                    img.load(self.fw.getPathByURL(card_item['display']))
                    painter.drawImage(QPoint(x, y), img)

        painter.end()
        r = image.save("preview" + str(self.currentID) + ".png", "PNG")

        pd = QDir(QDir.toNativeSeparators(QDir.currentPath() + "/preview" + str(self.currentID) + ".png"))

        self.imgReady.emit(self.fw.getUrl(pd.path()))





