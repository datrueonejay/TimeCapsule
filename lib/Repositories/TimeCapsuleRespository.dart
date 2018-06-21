import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:time_capsule/Constants/DatabaseConstants.dart';
import 'package:time_capsule/Models/TimeCapsuleDb.dart';

class TimeCapsuleRepository {
  TimeCapsuleRepository._internal();

  Database _db;
  static final TimeCapsuleRepository _timeCapsuleRepo =
    new TimeCapsuleRepository._internal();
  final _lock = new Lock();

  Future<Database> _getDb() async {
    if (_db == null) {
      await _lock.synchronized(() async{
          if (_db == null) {
            await create();
          }
      });
    }
    return _db;
  }

  static TimeCapsuleRepository get() {
    return  _timeCapsuleRepo;
  }

  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "timeCapsuleDatabase.db");
    _db = await openDatabase(dbPath, version: 1, onCreate: this._createTables);
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
  //endregion


  //region Query Methods
  Future<int> insertTimeCapsule(TimeCapsuleDb timeCapsule) async {
    var db = await _getDb();
    timeCapsule.id = await db.insert(DatabaseConstants.TimeCapsuleTableName, timeCapsule.toMap());
    return timeCapsule.id;
  }
  
  Future<TimeCapsuleDb> updateTimeCapsule(TimeCapsuleDb timeCapsule) async {
    var db = await _getDb();
    timeCapsule.id = await db.update(DatabaseConstants.TimeCapsuleTableName,
      timeCapsule.toMap(), where: "id = ?", whereArgs: [timeCapsule.id]);
    return timeCapsule;
  }

  Future<TimeCapsuleDb> getTimeCapsule(int id) async {
    var db = await _getDb();
    List<Map> results = await db.query(DatabaseConstants.TimeCapsuleTableName,
      columns: TimeCapsuleDb.columns, where: "id = ?", whereArgs: [id]);
    return TimeCapsuleDb.fromMap(results[0]);
  }

  Future<List<TimeCapsuleDb>> getAllTimeCapsules() async {
    var db = await _getDb();
    List<Map> results = await db.query(DatabaseConstants.TimeCapsuleTableName,
      columns: TimeCapsuleDb.columns);

    List<TimeCapsuleDb> timeCapsuleList = new List<TimeCapsuleDb>();
    results.forEach((currMap) {
      timeCapsuleList.add(TimeCapsuleDb.fromMap(currMap));
    });

    return timeCapsuleList;
  }
  //endregion
}