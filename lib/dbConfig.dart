import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbConfig {
  DbConfig._();
  static final DbConfig instance = DbConfig._();

  Database? _db;
  final _dbName = 'mydb.db';
  final _dbVersion = 1;

  Future<Database> getDatabase() async {
    if (_db != null) return _db!;
    _db = await _openDatabase();
    return _db!;
  }

  Future _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return await openDatabase(path,
        version: _dbVersion,
        onCreate: _onCreate,
        onConfigure: _onConfigure,
        readOnly: false);
  }

  // Future _deleteDatabase() async {
  //   final dbPath = await getDatabasesPath();
  //   final path = join(dbPath, _dbName);
  //   return await deleteDatabase(path);
  // }

  Future _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      create table category (
        _id integer primary key autoincrement, 
        name text not null
      )
    ''');
    await db.execute('''
      create table product (
        _id integer primary key autoincrement,
        category integer not null,
        name text not null,
        FOREIGN KEY (category) REFERENCES category (_id) ON DELETE CASCADE
      )
    ''');
  }
}
