import 'dart:convert';
import 'dart:io';
import 'package:clock_app/model/alarm_model.dart';
import 'package:clock_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'logging_service.dart';

class LocalStorage {
  static const String fileName = "alarms";
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    talker.info("Local Storage Directory :  ${directory.path}");

    return directory.path;
  }

  static Future<File> localFile() async {
    final path = await _localPath;
    return File('$path/$fileName.json');
  }

  // static Future<void> init() async {
  //   final file = await localFile("alarms");
  //   await file.create();
  //   var content = await file.readAsString();
  //   content.isEmpty ? file.writeAsString("") : null;
  // }

  static void createAlarm({
    required int alarmId,
    required TimeOfDay alarmDateTime,
    required String alarmLabel,
    required int isActive,
    required int isVibrate,
    required int isOnce,
    required int isMon,
    required int isTue,
    required int isWed,
    required int isThu,
    required int isFri,
    required int isSat,
    required int isSun,
  }) async {
    final file = await localFile();
    await file.create();
    var content = await file.readAsString();
    List alarmInfo = content != "" ? jsonDecode(content) : [];

    var model = {
      "alarmId": alarmId,
      "alarmDateTime": formatTimeOfDay(alarmDateTime),
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
      "isSun": isSun
    };

    alarmInfo.add(model);
    // for (var i = 0; i < alarmInfo.length; i++) {
    //   log(alarmInfo[i]);
    // }
    file.writeAsString(jsonEncode(alarmInfo));
  }

  static Future readAlarm() async {
    final file = await localFile();
    var content = await file.readAsString();
    talker.good(content);
    var alarms = content != "" ? alarmFromJson(content) : null;
    return alarms;
  }

  static void deleteDb() async {
    final file = await localFile();
    file.delete();
  }

  static void deleteAlarm(int index) async {
    final file = await localFile();

    var content = await file.readAsString();
    List alarmInfo = jsonDecode(content);
    alarmInfo.removeAt(index);
    file.writeAsString(jsonEncode(alarmInfo));

    for (var i = 0; i < alarmInfo.length; i++) {
      talker.log(alarmInfo[i]["alarmLabel"]);
    }
  }

  static void updateAlarm() {}
}
