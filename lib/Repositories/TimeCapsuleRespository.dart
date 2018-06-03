import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:time_capsule/Constants/DatabaseConstants.dart';
import 'package:time_capsule/Models/TimeCapsuleDb.dart';

class TimeCapsuleRepository {
  Database _db;
  TimeCapsuleRepository(this._db);

  Future<int> insertTimeCapsule(TimeCapsuleDb timeCapsule) async {
    timeCapsule.id = await _db.insert(DatabaseConstants.TimeCapsuleTableName, timeCapsule.toMap());
    return timeCapsule.id;
  }
  
  Future<TimeCapsuleDb> updateTimeCapsule(TimeCapsuleDb timeCapsule) async {
    timeCapsule.id = await _db.update(DatabaseConstants.TimeCapsuleTableName,
      timeCapsule.toMap(), where: "id = ?", whereArgs: [timeCapsule.id]);
    return timeCapsule;
  }

  Future<TimeCapsuleDb> getTimeCapsule(int id) async {
    List<Map> results = await _db.query(DatabaseConstants.TimeCapsuleTableName,
      columns: TimeCapsuleDb.columns, where: "id = ?", whereArgs: [id]);
    return TimeCapsuleDb.fromMap(results[0]);
  }

  Future<List<TimeCapsuleDb>> getAllTimeCapsules() async {
    List<Map> results = await _db.query(DatabaseConstants.TimeCapsuleTableName,
      columns: TimeCapsuleDb.columns);

    List<TimeCapsuleDb> timeCapsuleList = new List<TimeCapsuleDb>();
    results.forEach((currMap) {
      timeCapsuleList.add(TimeCapsuleDb.fromMap(currMap));
    });

    return timeCapsuleList;
  }

}