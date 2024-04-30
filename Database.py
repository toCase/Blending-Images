# This Python file uses the following encoding: utf-8
from PySide6.QtCore import QObject, QDate
from PySide6.QtSql import QSqlDatabase, QSqlQuery

class Database(QObject):

    connection_name: str

    TABLE_DIRECTORY = 'Directory'
    TABLE_FILES = 'Files'
    TABLE_PROJECT = 'Projects'
    TABLE_ITEMS = 'Items'


    def __init__(self, conn: str, parent = None):
        super().__init__(parent)
        self.connection_name = conn
        self.message_error_connect = "Нет соединения с базой данных"
        self.connectDB()


    def connectDB(self):
        db = QSqlDatabase.addDatabase('QSQLITE', self.connection_name)
        db.setDatabaseName("base.db3")
        db.open()
        if db.isOpen():
            qstr = [
                "CREATE TABLE IF NOT EXISTS Directory (id INTEGER PRIMARY KEY AUTOINCREMENT, dir TEXT)",
                "CREATE TABLE IF NOT EXISTS Files (id INTEGER PRIMARY KEY AUTOINCREMENT, dir INTEGER, file TEXT)",
                '''CREATE TABLE IF NOT EXISTS Projects (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, width INTEGER,
                height INTEGER, rows INTEGER, columns INTEGER, file TEXT, bg TEXT, upd INTEGER)''',
                "CREATE TABLE IF NOT EXISTS Items(id INTEGER PRIMARY KEY AUTOINCREMENT, project INTEGER, row INTEGER, col INTEGER, file INTEGER)",
            ]
            for q in qstr:
                query = QSqlQuery(q, db)
                query.exec()

    # GENERAL FUNCTION

    # получение данных
    def db_get(self, table: str, filter = None):
        db = QSqlDatabase.database(self.connection_name)
        if db.isOpen():
            data = []
            if table == self.TABLE_FILES:
                qstr = f"SELECT * FROM {table} WHERE {table}.dir = \'{filter}\' "
            elif table == self.TABLE_ITEMS:
                qstr = f"SELECT * FROM {table} WHERE {table}.project = \'{filter}\' "
            else:
                qstr = f"SELECT * FROM {table} "

            query = QSqlQuery(qstr, db)
            while query.next():
                d = {}
                for i in range(0, query.record().count()):
                    field = query.record().field(i)
                    d[field.name()] = query.value(i)

                    if table == self.TABLE_FILES:
                        d['selected'] = False

                data.append(d)
            return {'r':True, 'message':"", 'data':data}
        else:
            return {'r':False, 'message':self.message_error_connect, 'data':[]}

    # сохранение данных
    def db_save(self, card: dict, table:str):
        db = QSqlDatabase.database(self.connection_name)
        if db.isOpen():
            id = card.get('id')
            if id == 0:

                if table == self.TABLE_DIRECTORY:
                    qstr = "INSERT INTO Directory (dir) VALUES (?)"
                    query = QSqlQuery(qstr, db)
                    query.bindValue(0, card.get('dir'))

                elif table == self.TABLE_FILES:

                    qstr = "INSERT INTO Files (dir, file) VALUES (?, ?)"
                    query = QSqlQuery(qstr, db)
                    query.bindValue(0, card.get('dir'))
                    query.bindValue(1, card.get('file'))

                elif table == self.TABLE_PROJECT:
                    qstr = "INSERT INTO Projects (name, width, height, rows, columns, file, bg, upd) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
                    query = QSqlQuery(qstr, db)
                    query.bindValue(0, card.get('name'))
                    query.bindValue(1, card.get('width'))
                    query.bindValue(2, card.get('height'))
                    query.bindValue(3, card.get('rows'))
                    query.bindValue(4, card.get('columns'))
                    query.bindValue(5, card.get('file'))
                    query.bindValue(6, card.get('bg'))
                    query.bindValue(7, QDate.currentDate().toJulianDay())

                elif table == self.TABLE_ITEMS:
                    qstr = "INSERT INTO Items (project, row, col, file) VALUES (?, ?, ?, ?)"
                    query = QSqlQuery(qstr, db)
                    query.bindValue(0, card.get('project'))
                    query.bindValue(1, card.get('row'))
                    query.bindValue(2, card.get('col'))
                    query.bindValue(3, card.get('file'))

                r = query.exec()
                if r:
                    return {'r':r, 'message':'', 'id':int(query.lastInsertId()),}
                else:
                    return {'r':r, 'message':query.lastError().text(), 'id':0,}
            elif id > 0:

                if table == self.TABLE_DIRECTORY:
                    qstr = "UPDATE Directory SET dir = \'{}\' WHERE Directory.id = \'{}\'".format(card.get('dir'), id)

                elif table == self.TABLE_FILES:
                    qstr = "UPDATE Files SET dir = \'{}\', file = \'{}\' WHERE Files.id = \'{}\'".format(card.get('dir'), card.get('file'), id)

                elif table == self.TABLE_PROJECT:
                    qstr = '''UPDATE Projects SET name = \'{}\', width = \'{}\', height = \'{}\', rows = \'{}\',
                    columns = \'{}\', file = \'{}\', bg = \'{}\' WHERE Projects.id = \'{}\' '''.format(
                        card.get('name'), card.get('width'), card.get('height'), card.get('rows'), card.get('columns'),
                        card.get('file'), card.get('bg'), id)
                elif table == self.TABLE_ITEMS:
                    qstr = '''UPDATE Items SET project = \'{}\', row = \'{}\', col = \'{}\', file = \'{}\'
                    WHERE Items.id = \'{}\' '''.format(card.get('project'), card.get('row'), card.get('col'), card.get('file'), id)

                query = QSqlQuery(qstr, db)
                r = query.exec()
                if r:
                    return {'r':r, 'message':'', 'id':id,}
                else:
                    return {'r':r, 'message':query.lastError().text(), 'id':0,}
        else:
            return {'r':False, 'message':self.message_error_connect,}



    # удаление данных
    def db_del(self, id: int, table: str, filter = None):
        db = QSqlDatabase.database(self.connection_name)
        if db.isOpen():
            if table == self.TABLE_ITEMS and filter != None:
                qstr = f"DELETE FROM {table} WHERE {table}.project = \'{filter}\'"
            else:
                qstr = f"DELETE FROM {table} WHERE {table}.id = \'{id}\'"
            query = QSqlQuery(qstr, db)
            r = query.exec()
            if r:
                message = "Operation successful."
            else:
                message = query.lastError().text()
            return {'r': r, 'message': message}
        else:
            return {'r': False, 'message': self.message_error_connect}


    # DIRECTORY --------------


    # FILES------------------------
    def file_test(self, file: str):
        db = QSqlDatabase.database(self.connection_name)
        if db.isOpen():
            qstr = "SELECT Files.id FROM Files WHERE Files.file LIKE \'%\{0}\' OR Files.file LIKE \'%/{0}\'".format(file)
            query = QSqlQuery(qstr, db)
            if query.next():
                id = int(query.value(0))
                if id > 0:
                    return True
                else:
                    return False
            else:
                return False
        else:
            return False


    def getFile(self, id:int):
        db = QSqlDatabase.database(self.connection_name)
        if db.isOpen():
            qstr = f"SELECT Files.file FROM Files WHERE Files.id = \'{id}\'"
            query = QSqlQuery(qstr, db)
            if query.next():
                return str(query.value(0))
        return 0
