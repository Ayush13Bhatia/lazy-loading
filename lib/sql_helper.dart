import 'package:lazy_loading/person_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlHelper {
  static Future<void> createTable(Database db) async {
    await db.execute('CREATE TABLE person(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)');
  }

  static Future<Database> initializeDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'lazy_data.db'),
      onCreate: (db, version) {
        return createTable(db);
      },
      version: 1,
    );
    return database;
  }

  static Future<void> insertData(PersonModel person, {Database? database}) async {
    Database db = await initializeDB();
    await db.insert(
      'person',
      person.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<PersonModel>> readList(int offset) async {
    Database db = await initializeDB();
    var maps = [];
    maps = await db.query('person', limit: (offset * 10));
    print(maps);
    return maps.map((e) => PersonModel.fromJson(e)).toList();
  }

  Future<void> dbClose() async {
    Database db = await initializeDB();
    await db.close();
  }
}
