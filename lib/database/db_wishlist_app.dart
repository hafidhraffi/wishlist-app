import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database? _database;
List WholeDataList = [];

class DbWLApp {
  Future get database async {
    if (_database != null) return _database;
    _database = await _initializeDB('wlapplication.db');
    return _database;
  }

  Future _initializeDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        passwd TEXT NOT NULL
      );
      ''');
    await db.execute('''
      CREATE TABLE list(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        wish TEXT,
        quantity INTEGER,
        price TEXT,
        picdata BLOB,
        is_checked INTEGER,
        target_date TEXT,
        FOREIGN KEY (user_id) REFERENCES user(id)
      );
      ''');
  }

  Future<void> addUser({email, passwd}) async {
    final db = await database;
    await db.insert("user", {"email": email, "passwd": passwd});
  }

  Future<void> addList({userId, wish, quantity, price, picdata, targetDate}) async {
    final db = await database;
    await db.insert("list", {
      "user_id": userId,
      "wish": wish,
      "quantity": quantity,
      "price": price,
      "picdata": picdata,
      "is_checked": 0,
      "target_date": targetDate,
    });
  }

  Future<void> deleteList(int id) async {
    final db = await database;
    await db.delete("list", where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateList(int id,
      {userId, wish, quantity, price, picdata, targetDate}) async {
    final db = await database;
    await db.update(
        "list",
        {
          "user_id": userId,
          "wish": wish,
          "quantity": quantity,
          "price": price,
          "picdata": picdata,
          "target_date": targetDate,

        },
        where: 'id = ?',
        whereArgs: [id]);
  }

  Future<void> updateIsCheckedField(int id, int isChecked) async {
    final db = await database;
    await db.update("list", {"is_checked": isChecked},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getListsByUserId(int userId) async {
    final db = await database;
    return await db!.query('list', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<List<Map<String, dynamic>>> getUncheckedListsByUserId(
      int userId) async {
    final db = await database;
    return await db!.query('list',
        where: 'user_id = ? AND is_checked = ?', whereArgs: [userId, 0]);
  }

  Future<List<Map<String, dynamic>>> getCheckedListsByUserId(int userId) async {
    final db = await database;
    return await db!.query('list',
        where: 'user_id = ? AND is_checked = ?', whereArgs: [userId, 1]);
  }

  Future<Map<String, dynamic>?> getListByListId(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'list',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? maps.first : null;
  }

  // Future<void> addListManual() async {
  //   final db = await database;
  //   await db.insert("user", {"email": "agus@gmail.com", "passwd": "agus123"});
  //   // await db.insert("list", {"user_id": 3, "wish": "Jersey mills", "quantity": 1, "price": "Rp500.000,00"});
  // }

  // Future<void> readlistdata(userId) async {
  //   final db = await database;
  //   // final alldata = await db!.query('user');
  //   final alldata = await db!.query(
  //     'list', columns: ['is_checked'],
  //     // where: 'user_id = ?', whereArgs: [userId]
  //   );
  //   WholeDataList = alldata;
  //   print(WholeDataList);
  // }
}
