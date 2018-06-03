import 'dart:async';

import 'package:time_capsule/Models/TimeCapsule.dart';
import 'package:time_capsule/Models/TimeCapsuleDb.dart';
import 'package:time_capsule/Repositories/TimeCapsuleRespository.dart';

class TimeCapsuleController {

  TimeCapsuleRepository _timeCapsuleRepo;

  TimeCapsuleController(this._timeCapsuleRepo);

  Future<int> insertTimeCapsule(TimeCapsule timeCapsule) async {
    timeCapsule.id = await _timeCapsuleRepo.insertTimeCapsule(_toDbModel(timeCapsule));
    return timeCapsule.id;
  }

  setIsOpened(TimeCapsule timeCapsule) async {
    timeCapsule.isOpened = true;
    await _timeCapsuleRepo.updateTimeCapsule(_toDbModel(timeCapsule));
  }

  setIsDeleted(TimeCapsule timeCapsule) async {
    timeCapsule.isOpened = true;
    await _timeCapsuleRepo.updateTimeCapsule(_toDbModel(timeCapsule));
  }

  Future<List<TimeCapsule>> getUnopenedCapsules() async {
    List<TimeCapsuleDb> dbCapsules = await _timeCapsuleRepo.getAllTimeCapsules();
    List<TimeCapsule> timeCapsules = new List<TimeCapsule>();

    dbCapsules.forEach((dbCapsule) {
      TimeCapsule currCapsule = _toTimeCapsuleModel(dbCapsule);
      if (!currCapsule.isDeleted && !currCapsule.isOpened) {
        timeCapsules.add(currCapsule);
      }
    });
    return timeCapsules;
  }

  Future<List<TimeCapsule>> getAllCapsules() async {
    List<TimeCapsuleDb> dbCapsules = await _timeCapsuleRepo.getAllTimeCapsules();
    List<TimeCapsule> timeCapsules = new List<TimeCapsule>();

    dbCapsules.forEach((dbCapsule) {
      TimeCapsule currCapsule = _toTimeCapsuleModel(dbCapsule);
      if (!currCapsule.isDeleted) {
        timeCapsules.add(currCapsule);
      }
    });
    return timeCapsules;
  }

  TimeCapsuleDb _toDbModel(TimeCapsule timeCapsule) {
    TimeCapsuleDb dbModel = new TimeCapsuleDb();
    dbModel.title = timeCapsule.title;
    dbModel.message = timeCapsule.message;
    dbModel.createdDate = timeCapsule.createdDate.toUtc().toIso8601String();
    dbModel.openDate = timeCapsule.openDate.toUtc().toIso8601String();
    dbModel.isOpened = timeCapsule.isOpened ? 1 : 0;
    dbModel.isDeleted = timeCapsule.isDeleted ? 1 : 0;
    return dbModel;
  }

  TimeCapsule _toTimeCapsuleModel(TimeCapsuleDb timeCapsuleDb) {
    TimeCapsule timeCapsule = new TimeCapsule();
    timeCapsule.id = timeCapsuleDb.id;
    timeCapsule.title = timeCapsuleDb.title;
    timeCapsule.message = timeCapsuleDb.message;
    timeCapsule.createdDate = DateTime.parse(timeCapsuleDb.createdDate).toLocal();
    timeCapsule.openDate = DateTime.parse(timeCapsuleDb.openDate).toLocal();
    timeCapsule.isOpened = timeCapsuleDb.isOpened == 1 ? true : false;
    timeCapsule.isDeleted = timeCapsuleDb.isDeleted == 1 ? true : false;
    return timeCapsule;
  }

}