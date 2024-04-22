# This Python file uses the following encoding: utf-8
from PySide6.QtCore import QObject, Slot
from PySide6.QtSql import QSqlDatabase, QSqlQuery

class Database(QObject):

    connection_name: str

    def __init__(self, conn: str, parent = None):
        super().__init__(parent)
        self.connection_name = conn
        self.connectDB()


    def connectDB(self):
        db = QSqlDatabase.addDatabase('QSQLITE', self.connection_name)
        db.setDatabaseName("base.db3")
        db.open()
        if db.isOpen():
            qstr = "CREATE TABLE IF NOT EXISTS Directory (id INTEGER PRIMARY KEY AUTOINCREMENT, dir TEXT)"
            query = QSqlQuery(qstr, db)
            query.exec()

    @Slot(dict, result=dict)
    def directory_save(self, card: dict):
        db = QSqlDatabase.database(self.connection_name)
        if db.isOpen():
            id = card.get('id')
            if id == 0:
                qstr = "INSERT INTO Directory (dir) VALUES (?)"
                query = QSqlQuery(qstr, db)
                query.bindValue(0, card.get('dir'))
                r = query.exec()
                if r:
                    return {'r':r, 'message':'', 'id':int(query.lastInsertId()),}
                else:
                    return {'r':r, 'message':query.lastError().text(), 'id':0,}
            elif id > 0:
                qstr = "UPDATE Directory SET dir = \'{}\' WHERE Directory.id = \'{}\'".format(card.get('dir'), id)
                query = QSqlQuery(qstr, db)
                r = query.exec()
                if r:
                    return {'r':r, 'message':'', 'id':id,}
                else:
                    return {'r':r, 'message':query.lastError().text(), 'id':0,}

        else:
            return {'r':False, 'message':"Нет соединения с базой данных",}

    @Slot(int, result=dir)
    def directory_del(self, id: int):
        db = QSqlDatabase.database(self.connection_name)
        if db.isOpen():
            qstr = "DELETE FROM Directory WHERE Directory.id = \'{}\'".format(id)
            query = QSqlQuery(qstr, db)
            r = query.exec()
            message = query.lastError().text()
            return {'r':r, 'message':message,}
        else:
            return {'r':False, 'message':"Нет соединения с базой данных",}


    @Slot(result=dict)
    def directory_get(self):
        db = QSqlDatabase.database(self.connection_name)
        if db.isOpen():
            data = []
            qstr = "SELECT * FROM Directory "
            query = QSqlQuery(qstr, db)
            while query.next():
                d = {'id': query.value(0), 'dir':query.value(1)}
                data.append(d)
            return {'r':True, 'message':"", 'data':data}

        else:
            return {'r':False, 'message':"Нет соединения с базой данных", 'data':[]}
