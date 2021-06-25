import 'package:sqflite/sqflite.dart';
import 'dbConfig.dart';
import 'dbCategory.dart';

class ProductDB {
  Database? db;
  final tableName = 'product';
  CategoryDB categoryDB = new CategoryDB();

  Future database() async {
    db = await DbConfig.instance.getDatabase();
  }

  Future<int> insert(Map<String, dynamic> model) async {
    return await db!.insert(tableName, model);
  }

  // for modify list of map
  List<Map<String, dynamic>> mapModify(List<Map<String, dynamic>> results) {
    int length = results.length;
    Map<String, dynamic> generator(index) =>
        Map<String, dynamic>.from(results[index]);
    var generate =
        List<Map<String, dynamic>>.generate(length, generator, growable: true);
    return generate;
  }

  // get all product with related category object
  Future<List<Map<String, dynamic>>> getAll() async {
    await categoryDB.database();
    List<Map<String, dynamic>> products = await db!.query(tableName);
    var productList = mapModify(products);
    for (var product in productList) {
      int categoryId = int.parse(product['category'].toString());
      Map<String, dynamic> category = await categoryDB.getOne(categoryId);
      product['category'] = category;
    }
    return productList;
  }

  Future<Map<String, dynamic>> getOne(int id) async {
    List<Map<String, dynamic>> list =
        await db!.query(tableName, where: '_id = ?', whereArgs: [id]);
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
