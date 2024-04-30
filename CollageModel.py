# This Python file uses the following encoding: utf-8
from PySide6.QtCore import QAbstractTableModel, Qt, QModelIndex, Slot, Signal, QItemSelection, QItemSelectionModel
from PySide6.QtGui import QPainter, QColor
from PySide6.QtPrintSupport import QPrinter

from Database import Database
from misc import FileWorker

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


    def loadModel(self):
        pass

    @Slot(int, int, int, str)
    def setProject(self, project:int, rows:int, cols:int, bg:str):
        self.project = project
        self.project_rows = rows
        self.project_cols = cols
        self.project_bg = bg
        self.generateModel()

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
                           _display = self.db.getFile(_file)

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
                card['display'] = self.db.getFile(file_id)
            else:
                card['displayType'] = False
                card['display'] = ""

            card['selected'] = True
            row_data[column] = card
            self.map[row] = row_data

            self.endResetModel()
        else:
            print("ERROR ADD FILE: ", res['message'])

    @Slot(int, int, result=dict)
    def makeCollage(self, row:int, column:int,):
        data_row = self.map[row]
        card = data_row.get(column)
        print("C: ", card)
        return card

    @Slot(result=str)
    def getBG(self):
        return self.project_bg

    @Slot(str, result=str)
    def getFile(self, f:str):
        return self.fw.getPathByURL(f)


    @Slot(str)
    def printPDF(self, fname:str):
        f = self.fw.getPathByURL(fname)
        printer = QPrinter()
        printer.setOutputFormat(QPrinter.PdfFormat)
        printer.setOutputFileName(f)

        painter = QPainter(printer)
        painter.setBackground(QColor(self.project_bg))
        painter.drawText(10, 10, "Test 2")
        painter.end()










