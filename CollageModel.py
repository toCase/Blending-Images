# Blending Images
# ------------------------------------------
# Модель данных для создания коллажа
# ------------------------------------------

from PySide6.QtCore import QAbstractTableModel, Qt, QModelIndex, Slot, QPoint
from PySide6.QtGui import QPainter, QColor, QImage, QPageSize
from PySide6.QtPrintSupport import QPrinter
from Database import Database
from misc import FileWorker
import platform

from PIL import Image

class CollageModel(QAbstractTableModel):

    DISPLAY = Qt.DisplayRole
    DISPLAY_TYPE = Qt.UserRole + 1
    ID = Qt.UserRole + 2
    SELECTED = Qt.UserRole + 3


    def __init__(self, parent=None):
        super().__init__(parent)
        self.db = Database("CM")
        self.fw = FileWorker("CMFW")

        self.map = []
        self.project = 0
        self.project_rows = 1
        self.project_cols = 1
        self.project_bg = ""

        self.loadModel()

    # --перегрузка стандартных функций

    @Slot(result=int)
    def rowCount(self, parent=None):
        return self.project_rows

    @Slot(result=int)
    def columnCount(self, parent=None):
        return self.project_cols

    def data(self, index: QModelIndex, role=Qt.DisplayRole):
        r = None
        row = index.row()
        col = index.column()
        card = self.map[row].get(col)

        if role == self.DISPLAY:
            r = card.get('display')
        elif role == self.DISPLAY_TYPE:
            r = card.get('displayType')
        elif role == self.ID:
            r = card.get('id')
        elif role == self.SELECTED:
            r = card.get('selected')

        return r

    def roleNames(self):
        return {
        self.DISPLAY:b"display",
        self.DISPLAY_TYPE:b"displayType",
        self.ID:b"idx",
        self.SELECTED:b"selected",
    }

    # --загрузка модели -- не используем ---
    def loadModel(self):
        pass

    # -- устанавливаем текущий проект
    @Slot(int, int, int, str)
    def setProject(self, project:int, rows:int, cols:int, bg:str):
        self.project = project
        self.project_rows = rows
        self.project_cols = cols
        self.project_bg = bg
        self.generateModel()

    # -- генерируем модель
    def generateModel(self):
        self.beginResetModel()

        self.map.clear()
        x = self.db.db_get(self.db.TABLE_ITEMS, self.project)
        if x['r']:
            _data = x['data']

            for r in range (0, self.project_rows, 1):
                _row = {}
                for item in _data:
                    if item['row'] == r:
                        _id = item['id']
                        _file = item['file']
                        if _file == 0:
                            _type = False
                            _display = self.project_bg
                        else:
                           _type = True
                           _display = self.fw.getUrl(self.db.getFile(_file))

                        _row[item['col']] = {'id':_id, 'file':_file, 'displayType':_type, 'display': _display, 'selected': False}
                self.map.append(_row)


        # self.map.clear()
        # for r in range(0, self.project_rows, 1):
        #     row = {}
        #     for c in range(0, self.project_cols, 1):
        #         row[c] = {'id':0, 'displayType':False, 'display': self.project_bg, 'selected': False}
        #     self.map.append(row)
        # print(self.map)
        self.endResetModel()

    # -- устанавливаем текущую ячейку
    @Slot(int, int)
    def setCurrentCell(self, row:int, column:int):
        self.beginResetModel()
        for r in range(0, len(self.map), 1):
            row_data = self.map[r]
            for c in range(0, len(row_data.keys()), 1):
                card = self.map[r].get(c)
                if card.get('selected'):
                    card['selected'] = False
                    row_data[c] = card
                    self.map[r] = row_data
                    break

        row_data = self.map[row]
        card = row_data.get(column)
        card['selected'] = True

        row_data[column] = card
        self.map[row] = row_data
        # print (self.map)
        self.endResetModel()

    # -- привязываем файл к проекту
    @Slot(int, int, int)
    def makeFile(self, row:int, column:int, file_id:int):


        row_data = self.map[row]
        card = row_data.get(column)

        # print("CARD: ", card)

        # save to db
        d = {
            'id':card['id'],
            'project':self.project,
            'row':row,
            'col':column,
            'file': file_id
        }
        res = self.db.db_save(d, self.db.TABLE_ITEMS)
        if res['r']:

            self.beginResetModel()

            for r in range(0, len(self.map), 1):
                _row_data = self.map[r]
                for c in range(0, len(row_data.keys()), 1):
                    _card = self.map[r].get(c)
                    if _card.get('selected'):
                        _card['selected'] = False
                        _row_data[c] = _card
                        self.map[r] = _row_data
                        break

            if file_id:
                card['displayType'] = True
                card['display'] = self.fw.getUrl(self.db.getFile(file_id))
            else:
                card['displayType'] = False
                card['display'] = ""

            card['selected'] = True
            row_data[column] = card
            self.map[row] = row_data

            self.endResetModel()
        else:
            print("ERROR ADD FILE: ", res['message'])

    # --получить карту модели
    @Slot(int, int, result=dict)
    def makeCollage(self, row:int, column:int,):
        data_row = self.map[row]
        card = data_row.get(column)
        return card

    # -- получить фон --
    @Slot(result=str)
    def getBG(self):
        return self.project_bg

    # -- получить файл
    @Slot(str, result=str)
    def getFile(self, f:str):
        return self.fw.getPathByURL(f)

    # --печать в ПДФ -- не используется --
    @Slot(str)
    def printPDF(self, fname: str):
        f = self.fw.getPathByURL(fname)
        printer = QPrinter()
        printer.setOutputFormat(QPrinter.PdfFormat)
        printer.setPageSize(QPageSize(QPageSize.A5))  # Установка размера страницы A5
        printer.setOutputFileName(f)

        painter = QPainter(printer)
        painter.setPen(QColor(self.project_bg))

        page_width = printer.width()
        page_height = printer.height()

        # Создаем новое изображение для компоновки всех частей изображения
        full_image = QImage(self.project_cols * 76, self.project_rows * 85, QImage.Format_RGB32)
        full_image.fill(QColor(self.project_bg))  # Заливаем фон цветом проекта

        # Проходим по всем частям изображения и рисуем их на полном изображении
        for r in range(0, self.project_rows):
            for c in range(0, self.project_cols):
                card = self.makeCollage(r, c)

                x = c * 76
                y = r * 85

                if card['displayType']:
                    part_image = QImage()
                    part_image.load(self.fw.getPathByURL(card['display']))

                    painter = QPainter(full_image)
                    painter.drawImage(QPoint(x, y), part_image)
                    painter.end()

        # Теперь масштабируем и центрируем полное изображение на странице A5
        painter.begin(printer)
        painter.setPen(QColor(self.project_bg))

        # Определяем масштаб для умещения изображения в области страницы A5 с отступами
        scale_factor = min(page_width / full_image.width(), page_height / full_image.height())

        if scale_factor < 1:
            scaled_width = full_image.width() * scale_factor
            scaled_height = full_image.height() * scale_factor

            # Рассчитываем координаты для центрирования изображения на странице A5
            start_x = (page_width - scaled_width) / 2
            start_y = (page_height - scaled_height) / 2

            # Рисуем масштабированное и центрированное изображение на странице A5
            painter.drawImage(QPoint(start_x, start_y), full_image.scaled(scaled_width, scaled_height, Qt.KeepAspectRatio, Qt.SmoothTransformation))
        else:

            start_x = (page_width - full_image.width()) / 2
            start_y = (page_height - full_image.height()) / 2
            painter.drawImage(QPoint(start_x, start_y), full_image)

        painter.end()

    # --сохранение в файл -- не используется --
    @Slot(str)
    def saveImage(self, fname:str):
        f = self.fw.getPathByURL(fname)

        # Создание изображения размером, соответствующим вашему проекту
        image = QImage(self.project_cols * 76, self.project_rows * 85, QImage.Format_RGB32)
        image.fill(QColor(self.project_bg))  # Заливка фона цветом проекта

        painter = QPainter(image)
        for r in range(0, self.project_rows):
            for c in range(0, self.project_cols):
                card = self.makeCollage(r, c)
                x = c * 76
                y = r * 85

                if card['displayType']:
                    img = QImage()
                    img.load(self.fw.getPathByURL(card['display']))
                    painter.drawImage(QPoint(x, y), img)
                # else:
                #     rect = QRectF(x, y, 76.0, 85.0)
                #     painter.drawRect(rect)
                #     painter.fillRect(rect, QColor(self.project_bg))

        painter.end()

        # Сохранение изображения в формате JPG
        image.save(f, "JPG")

    # -- сохранение в файл
    @Slot(str)
    def saveImagePIL(self, fname:str):
        f = self.fw.getPathByURL(fname)

        # Создание изображения с использованием Pillow
        image = Image.new('RGB', (self.project_cols * 76, self.project_rows * 85), color=self.project_bg)
        for r in range(self.project_rows):
            for c in range(self.project_cols):
                card = self.makeCollage(r, c)
                x = c * 76
                y = r * 85

                if card['displayType']:
                    img = Image.open(self.fw.getPathByURL(card['display']))
                    image.paste(img, (x, y))
        image.save(f, format='JPEG')

    # -- сохранение в ПДФ
    @Slot(str)
    def printPillowPDF(self, fname: str):
        f = self.fw.getPathByURL(fname)

        # Создаем новое изображение для компоновки всех частей изображения
        full_image = Image.new('RGB', (self.project_cols * 76, self.project_rows * 85), color=self.project_bg)

        # Проходим по всем частям изображения и рисуем их на полном изображении
        for r in range(0, self.project_rows):
            for c in range(0, self.project_cols):
                card = self.makeCollage(r, c)
                x = c * 76
                y = r * 85

                if card['displayType']:
                    part_image = Image.open(self.fw.getPathByURL(card['display']))
                    full_image.paste(part_image, (x, y))

        # Теперь у нас есть полное изображение с добавленными частями или прямоугольниками на фоне


        # Проверяем размер собранного изображения и масштабируем его при необходимости
        intend = self.getSetting() * 2

        max_width = (148 - intend) * 3.7795275591  # ширина страницы A5 с отступами в 10 мм с обеих сторон
        max_height = (210 - intend) * 3.7795275591  # высота страницы A5 с отступами в 10 мм с обеих сторон

        scale_factor = min(max_width / full_image.width, max_height / full_image.height)

        if scale_factor < 1:
            # Необходимо масштабировать изображение

            scaled_width = int(full_image.width * scale_factor)
            scaled_height = int(full_image.height * scale_factor)

            print("scaled_width :", scaled_width)
            print("scaled_height :", scaled_height)

            # Масштабируем изображение с сохранением пропорций
            full_image = full_image.resize((scaled_width, scaled_height), resample=Image.LANCZOS)

        full_image.save("temp", format='JPEG')

        # Создаем QPrinter для печати в PDF
        printer = QPrinter()
        printer.setOutputFormat(QPrinter.PdfFormat)
        printer.setPageSize(QPageSize(QPageSize.A5))  # Установка размера страницы A5
        printer.setOutputFileName(f)

        painter = QPainter(printer)
        painter.setPen(QColor(self.project_bg))

        page_width = printer.width()
        page_height = printer.height()

        # Рассчитываем координаты для центрирования изображения на странице A5
        start_x = (page_width - full_image.width) / 2
        start_y = (page_height - full_image.height) / 2

        # Рисуем изображение на странице A5
        print_img = QImage()
        print_img.load("temp")
        painter.drawImage(QPoint(start_x, start_y), print_img)

        painter.end()
        self.fw.removeTempFile()

    # -- ?? -------------
    @Slot(result=bool)
    def testWin(self):
        if platform.system() == "Windows":
            return True
        return False

    # -- получить установку отступа
    @Slot(result=int)
    def getSetting(self):
        sett = self.fw.getJsonSetting()
        if sett["intend"] == None:
            print("NONE")
            return 10
        else:
            return sett["intend"]

    # -- сохранить установку отступа
    @Slot(int)
    def setSetting(self, x:int):
        sett = {}
        sett["intend"] = x
        self.fw.setJsonSetting(sett)










