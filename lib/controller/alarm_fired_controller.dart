import 'dart:io';

import 'package:clock_app/controller/alarm_controller.dart';
import 'package:clock_app/utils/services/logging_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/alarm_model.dart';
import '../utils/globals.dart';

class AlarmFireController extends GetxController
    with StateMixin<Alarm>, GetTickerProviderStateMixin {
  late AlarmController alarmController;
  late final RxInt _alarmId = 0.obs;

  void arg(int id) {
    _alarmId.value = id;
  }

  @override
  void onInit() async {
    super.onInit();

    alarmController = Get.put(AlarmController());
    try {
      List<Alarm>? alarm = await alarmController.readAlarms();
      for (var i = 0; i < alarm!.length; i++) {
        if (alarm[i].alarmId == _alarmId.value) {
          change(alarm[i], status: RxStatus.success());
          Future.delayed(const Duration(minutes: 1), () {
            TimeOfDay timeOfDay = stringToTimeOfDay(alarm[i].alarmDateTime);

            DateTime now = DateTime.now();

            DateTime scheduleTime = DateTime(now.year, now.month, now.day,
                    timeOfDay.hour, timeOfDay.minute)
                .add(const Duration(minutes: 2));
            alarmController.snoozeAlarm(
              alarm[i].index,
              alarm[i].alarmId,
              scheduleTime,
            );
            exit(0);
          });
          return;
        }
      }
    } catch (e) {
      talker.error(e);
      change(null, status: RxStatus.error());
    }
  }
}
