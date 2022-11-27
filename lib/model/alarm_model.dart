// To parse this JSON data, do
//
//     final alarm = alarmFromJson(jsonString);

import 'dart:convert';

List<Alarm> alarmFromJson(String str) =>
    List<Alarm>.from(json.decode(str).map((x) => Alarm.fromJson(x)));

String alarmToJson(List<Alarm> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Alarm {
  Alarm({
    required this.index,
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

  int index;
  int alarmId;
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

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        index: json["index"],
        alarmId: json["alarmId"],
        alarmDateTime: json["alarmDateTime"],
        alarmLabel: json["alarmLabel"],
        isActive: json["isActive"],
        isVibrate: json["isVibrate"],
        isOnce: json["isOnce"],
        isMon: json["isMon"],
        isTue: json["isTue"],
        isWed: json["isWed"],
        isThu: json["isThu"],
        isFri: json["isFri"],
        isSat: json["isSat"],
        isSun: json["isSun"],
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "alarmId": alarmId,
        "alarmDateTime": alarmDateTime,
        "alarmLabel": alarmLabel,
        "isActive": isActive,
        "isVibrate": isVibrate,
        "isOnce": isOnce,
        "isMon": isMon,
        "isTue": isTue,
        "isWed": isWed,
        "isThu": isThu,
        "isFri": isFri,
        "isSat": isSat,
        "isSun": isSun,
      };
}
