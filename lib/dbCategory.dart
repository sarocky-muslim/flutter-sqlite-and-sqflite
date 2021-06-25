import 'package:sqflite/sqflite.dart';
import 'dbConfig.dart';

class CategoryDB {
  Database? db;
  final tableName = 'category';

  Future database() async {
    db = await DbConfig.instance.getDatabase();
  }

  Future<int> insert(Map<String, dynamic> model) async {
    return await db!.insert(tableName, model);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    return await db?.query(tableName) ?? [];
  }

  Future<Map<String, dynamic>> getOne(int id) async {
    List<Map<String, dynamic>> list =
        await db!.query(tableName, where: '_id = ?', whereArgs: [id]);
    // print('getOne list $list');
    return list.first;
  }

  Future<int> update(Map<String, dynamic> model) async {
    return await db!
        .update(tableName, model, where: '_id = ?', whereArgs: [model['_id']]);
  }

  Future<int> delete(int id) async {
    return await db!.delete(tableName, where: '_id = ?', whereArgs: [id]);
  }

  Future close() async => db!.close();
}
