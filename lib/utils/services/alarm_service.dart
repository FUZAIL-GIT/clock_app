import 'dart:async';
import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:clock_app/main.dart';
import 'package:clock_app/model/alarm_model.dart';
import 'package:clock_app/utils/services/local_notification_service.dart';
import 'package:clock_app/utils/services/local_storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';

import '../../view/screens/alarmdetails_view.dart';
import 'logging_service.dart';

class AlarmService {
  //set the alarm in android alarm manager
  static Future<void> setAlarm(DateTime scheduleTime, int alarmId) async {
    DateTime now = DateTime.now();
    DateTime dateTime = scheduleTime.compareTo(now) < 0
        ? scheduleTime.add(const Duration(days: 1))
        : scheduleTime;
    if (scheduleTime.compareTo(now) < 0) {
      talker.info("The alarm time is in the past");
    }
    talker.info("Alarm set on :$dateTime");

    await AndroidAlarmManager.oneShotAt(
      dateTime,
      alarmId,
      playAlarm,
      rescheduleOnReboot: true,
      wakeup: true,
      exact: true,
      alarmClock: true,
    );
  }

  static Future<void> deleteAlarm(int alarmId) async {
    try {
      AndroidAlarmManager.cancel(alarmId);
      talker.info("Alarm DeActivated (AlarmId : $alarmId)");
    } catch (e) {
      talker.log(e);
    }
  }

  //!play alarm
  static void playAlarm(int alarmId) async {
    alarmMedia();
    talker.log("ID : $alarmId");
    // if (Platform.isAndroid) {
    //   restartApp();
    //   Timer(const Duration(seconds: 5), () {
    //     Bringtoforeground.bringAppToForeground();
    //   });
    // }
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => AlarmDetails(),

    //   ),
    // );
    //call local notification
    List<Alarm> alarms = await LocalStorage.readAlarm();
    for (var i = 0; i < alarms.length; i++) {
      if (alarms[i].alarmId == alarmId) {
        talker.log(alarms[i].alarmLabel);
        LocalNotification.showNotification(
          id: alarmId,
          body: alarms[i].alarmDateTime,
          title: alarms[i].alarmLabel,
          payLoad: alarmId.toString(),
        );
        return;
      }
    }
  }

  static void alarmMedia() async {
    final Iterable<Duration> pauses = [
      const Duration(milliseconds: 500),
      const Duration(milliseconds: 1000),
      const Duration(milliseconds: 500),
      const Duration(milliseconds: 1000),
      const Duration(milliseconds: 500),
      const Duration(milliseconds: 1000),
      const Duration(milliseconds: 500),
      const Duration(milliseconds: 1000),
      const Duration(milliseconds: 500),
      const Duration(milliseconds: 1000),
      const Duration(milliseconds: 500),
    ];

    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.vibrateWithPauses(pauses);
    }
    FlutterRingtonePlayer.play(
      android: AndroidSounds.alarm,

      ios: IosSounds.glass,
      looping: false, // Android only - API >= 28
      volume: 10, // Android only - API >= 28
      asAlarm: true, // Android only - all APIs
    );
  }
}
