import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  Future<Database> opendb()
  async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');


    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, subject TEXT)');
        });

    return database;

  }
}