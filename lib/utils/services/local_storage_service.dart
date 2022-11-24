import 'dart:convert';
import 'dart:io';
import 'package:clock_app/model/alarm_model.dart';
import 'package:clock_app/utils/globals.dart';
import 'package:clock_app/utils/services/alarm_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'logging_service.dart';

class LocalStorage {
  static const String fileName = "alarms";
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // talker.info("Local Storage Directory :  ${directory.path}");

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
      "alarmDateTime": timeOfDaytoString(alarmDateTime),
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

  static Future<void> deleteAlarm(int index) async {
    final file = await localFile();

    var content = await file.readAsString();
    List alarmInfo = jsonDecode(content);
    alarmInfo.removeAt(index);
    file.writeAsString(jsonEncode(alarmInfo));

    for (var i = 0; i < alarmInfo.length; i++) {
      talker.log(alarmInfo[i]["alarmLabel"]);
    }
  }

  static Future<void> updateAlarmStatus(
      int index, int alarmId, var model) async {
    final file = await localFile();

    var content = await file.readAsString();
    List alarmInfo = jsonDecode(content);
    for (var i = 0; i < alarmInfo.length; i++) {
      if (alarmInfo[i]["alarmId"] == alarmId) {
        alarmInfo.removeAt(index);
        alarmInfo.insert(index, model);
        if (model["isActive"] == 0) {
          AlarmService.deleteAlarm(alarmId);
        }
        if (model["isActive"] == 1) {
          TimeOfDay selectedTime = stringToTimeOfDay(model["alarmDateTime"]);
          DateTime now = DateTime.now();
          DateTime scheduleTime = DateTime(now.year, now.month, now.day,
              selectedTime.hour, selectedTime.minute);

          AlarmService.setAlarm(scheduleTime, model["alarmId"]);
        }
        file.writeAsString(jsonEncode(alarmInfo));

        return;
      }
    }
  }

  static Future<void> updateAlarm(int index, int alarmId, var model) async {
    final file = await localFile();

    var content = await file.readAsString();
    List alarmInfo = jsonDecode(content);
    for (var i = 0; i < alarmInfo.length; i++) {
      if (alarmInfo[i]["alarmId"] == alarmId) {
        alarmInfo.removeAt(index);
        alarmInfo.insert(index, model);

        await AlarmService.deleteAlarm(alarmId);

        TimeOfDay selectedTime = stringToTimeOfDay(model["alarmDateTime"]);
        DateTime now = DateTime.now();
        DateTime scheduleTime = DateTime(now.year, now.month, now.day,
            selectedTime.hour, selectedTime.minute);

        await AlarmService.setAlarm(scheduleTime, model["alarmId"]);

        file.writeAsString(jsonEncode(alarmInfo));

        return;
      }
    }
  }
}
