import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:time_capsule/Models/TimeCapsule.dart';

class TimeCapsuleRepository {
  Database _db;
  TimeCapsuleRepository(this._db);

  Future<int> insertTimeCapsule(TimeCapsule timeCapsule) async {
    timeCapsule.id = await _db.insert("TimeCapsules", timeCapsule.toMap());
    return timeCapsule.id;
  }

}