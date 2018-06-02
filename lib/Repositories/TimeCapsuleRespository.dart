import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:time_capsule/Constants/DatabaseConstants.dart';
import 'package:time_capsule/Models/TimeCapsule.dart';

class TimeCapsuleRepository {
  Database _db;
  TimeCapsuleRepository(this._db);

  Future<int> insertTimeCapsule(TimeCapsule timeCapsule) async {
    timeCapsule.id = await _db.insert(DatabaseConstants.TimeCapsuleTableName, timeCapsule.toMap());
    return timeCapsule.id;
  }
  
  Future<TimeCapsule> updateTimeCapsule(TimeCapsule timeCapsule) async {
    timeCapsule.id = await _db.update(DatabaseConstants.TimeCapsuleTableName,
      timeCapsule.toMap(), where: "id = ?", whereArgs: [timeCapsule.id]);
    return timeCapsule;
  }

  Future<TimeCapsule> getTimeCapsule(int id) async {
    List<Map> results = await _db.query(DatabaseConstants.TimeCapsuleTableName,
      columns: TimeCapsule.columns, where: "id = ?", whereArgs: [id]);
    return TimeCapsule.fromMap(results[0]);
  }

  Future<List<TimeCapsule>> getAllTimeCapsules() async {
    List<Map> results = await _db.query(DatabaseConstants.TimeCapsuleTableName,
      columns: TimeCapsule.columns);

    List<TimeCapsule> timeCapsuleList = new List<TimeCapsule>();
    results.forEach((currMap) {
      timeCapsuleList.add(TimeCapsule.fromMap(currMap));
    });

    return timeCapsuleList;
  }


}