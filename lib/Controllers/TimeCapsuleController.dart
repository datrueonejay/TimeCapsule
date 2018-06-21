import 'dart:async';

import 'package:time_capsule/Models/TimeCapsule.dart';
import 'package:time_capsule/Models/TimeCapsuleDb.dart';
import 'package:time_capsule/Repositories/TimeCapsuleRespository.dart';

class TimeCapsuleController {

  Future<int> insertTimeCapsule(TimeCapsule timeCapsule) async {
    timeCapsule.id = await TimeCapsuleRepository.get().insertTimeCapsule(_toDbModel(timeCapsule));
    return timeCapsule.id;
  }

  setIsOpened(TimeCapsule timeCapsule) async {
    timeCapsule.isOpened = true;
    await TimeCapsuleRepository.get().updateTimeCapsule(_toDbModel(timeCapsule));
  }

  setIsDeleted(TimeCapsule timeCapsule) async {
    timeCapsule.isOpened = true;
    await TimeCapsuleRepository.get().updateTimeCapsule(_toDbModel(timeCapsule));
  }

  Future<List<TimeCapsule>> getReadyCapsules() async {
    List<TimeCapsuleDb> dbCapsules = await TimeCapsuleRepository.get().getAllTimeCapsules();
    List<TimeCapsule> timeCapsules = new List<TimeCapsule>();

    dbCapsules.forEach((dbCapsule) {
      TimeCapsule currCapsule = _toTimeCapsuleModel(dbCapsule);
      if (!currCapsule.isDeleted && !currCapsule.isOpened && currCapsule.openDate.isBefore(DateTime.now())) {
        timeCapsules.add(currCapsule);
      }
    });
    timeCapsules.sort((capsuleOne, capsuleTwo) {
      return capsuleOne.openDate.compareTo(capsuleTwo.openDate);
    });
    return timeCapsules;
  }

  Future<List<TimeCapsule>> getAllCapsules() async {
    List<TimeCapsuleDb> dbCapsules = await TimeCapsuleRepository.get().getAllTimeCapsules();
    List<TimeCapsule> timeCapsules = new List<TimeCapsule>();

    dbCapsules.forEach((dbCapsule) {
      TimeCapsule currCapsule = _toTimeCapsuleModel(dbCapsule);
      if (!currCapsule.isDeleted) {
        timeCapsules.add(currCapsule);
      }
    });
    timeCapsules.sort((capsuleOne, capsuleTwo) {
      return capsuleOne.openDate.compareTo(capsuleTwo.openDate);
    });
    return timeCapsules;
  }

  Future<List<TimeCapsule>> getTimeCapsulesBefore(DateTime beforeDate) async {
    List<TimeCapsuleDb> dbCapsules = await TimeCapsuleRepository.get().getAllTimeCapsules();
    List<TimeCapsule> timeCapsules = new List<TimeCapsule>();

    dbCapsules.forEach((dbCapsule) {
      TimeCapsule currCapsule = _toTimeCapsuleModel(dbCapsule);
      // date for today
      DateTime today = DateTime.now();
      today = DateTime(today.year, today.month, today.day, 0, 0, 0, 0, 0);
      if (!currCapsule.isDeleted && currCapsule.openDate.isBefore(beforeDate) && currCapsule.openDate.isAfter(today)) {
        timeCapsules.add(currCapsule);
      }
    });
    timeCapsules.sort((capsuleOne, capsuleTwo) {
      return capsuleOne.openDate.compareTo(capsuleTwo.openDate);
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