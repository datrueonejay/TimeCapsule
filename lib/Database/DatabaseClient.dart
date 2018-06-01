import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseClient {
  Database _db;

  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "timeCapsuleDatabase.db");
    _db = await openDatabase(dbPath, version: 1, onCreate: this._createTables);
  }

  Future _createTables(Database db, int version) async {
    await db.execute("""
      CREATE TABLE TimeCapsules (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        createdDate TEXT NOT NULL,
        openDate TEXT NOT NULL,
        isOpened INTEGER NOT NULL,
        isDeleted INTEGER NOT NULL
      )
      """);
  }
}