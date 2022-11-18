import 'dart:convert';

AlarmInfo alarmInfoFromJson(String str) => AlarmInfo.fromJson(json.decode(str));
String alarmInfoToJson(AlarmInfo alarmInfo) =>
    json.encode(alarmInfo.toString());

class AlarmInfo {
  int alarmId;
  int? id;
  String alarmDateTime;
  String alarmLabel;
  int isActive;
  int isVibrate;
  int isOnce;
  int isMon;
  int isTue;
  int isWed;
  int isThu;
  int isFri;
  int isSat;
  int isSun;

  AlarmInfo({
    this.id,
    required this.alarmId,
    required this.alarmDateTime,
    required this.alarmLabel,
    required this.isActive,
    required this.isVibrate,
    required this.isOnce,
    required this.isMon,
    required this.isTue,
    required this.isWed,
    required this.isThu,
    required this.isFri,
    required this.isSat,
    required this.isSun,
  });

  // Map<String, Object?> toMap() => {
  //       "alarmDateTime": alarmDateTime.toString(),
  //       "alarmLabel": alarmLabel,
  //       "isActive": isActive,
  //       "isVibrate": isVibrate,
  //       "isMon": isMon,
  //       "isTue": isTue,
  //       "isWed": isWed,
  //       "isThu": isThu,
  //       "isFri": isFri,
  //       "isSat": isSat,
  //       "isSun": isSun,
  //     };

// METHOD TO CONVERT IN JSON FORMAT
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["alarmId"] = alarmId;
    data["id"] = id;
    data["alarmDateTime"] = alarmDateTime;
    data["alarmLabel"] = alarmLabel;
    data["isActive"] = isActive;
    data["isVibrate"] = isVibrate;
    data["isOnce"] = isOnce;
    data["isMon"] = isMon;
    data["isTue"] = isTue;
    data["isWed"] = isWed;
    data["isThu"] = isThu;
    data["isFri"] = isFri;
    data["isSat"] = isSat;
    data["isSun"] = isSun;
    return data;
  }

  factory AlarmInfo.fromJson(Map<String, dynamic> data) => AlarmInfo(
        alarmId: data["alarmId"],
        id: data["id"],
        alarmDateTime: data["alarmDateTime"],
        alarmLabel: data["alarmLabel"],
        isActive: data["isActive"],
        isVibrate: data["isVibrate"],
        isOnce: data["isOnce"],
        isMon: data["isMon"],
        isTue: data["isTue"],
        isWed: data["isWed"],
        isThu: data["isThu"],
        isFri: data["isFri"],
        isSat: data["isSat"],
        isSun: data["isSun"],
      );
}
