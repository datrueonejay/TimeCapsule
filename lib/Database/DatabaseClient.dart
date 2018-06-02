import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:time_capsule/Constants/DatabaseConstants.dart';

class DatabaseClient {
  Database db;

  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "timeCapsuleDatabase.db");
    db = await openDatabase(dbPath, version: 1, onCreate: this._createTables);
  }

  Future _createTables(Database db, int version) async {
    await db.execute("""
      CREATE TABLE ${DatabaseConstants.TimeCapsuleTableName} (
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