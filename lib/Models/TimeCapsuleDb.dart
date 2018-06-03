class TimeCapsuleDb {

  int id;
  String title;
  String message;
  String createdDate;
  String openDate;
  int isOpened;
  int isDeleted;

  static final columns = ["id", "title", "message", "createDate", "openDate",
  "isOpened", "isDeleted"];

  Map toMap() {
    Map<String, dynamic> map = new Map.from({
      "title": title,
      "message": message,
      "createdDate": createdDate,
      "openDate": openDate,
      "isOpened": isOpened,
      "isDeleted": isDeleted
    });

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  static TimeCapsuleDb fromMap(Map map) {
    TimeCapsuleDb timeCapsule = new TimeCapsuleDb();
    timeCapsule.id = map["id"];
    timeCapsule.title = map["title"];
    timeCapsule.message = map["message"];
    timeCapsule.createdDate = map["createdDate"];
    timeCapsule.openDate = map["openDate"];
    timeCapsule.isOpened = map["isOpened"];
    timeCapsule.isDeleted = map["isDeleted"];

    return timeCapsule;
  }
}