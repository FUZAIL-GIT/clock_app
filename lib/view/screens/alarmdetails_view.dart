// ignore_for_file: unused_local_variable
import 'dart:developer';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:clock_app/controller/alarm_controller.dart';
import 'package:clock_app/controller/alarm_fired_controller.dart';
import 'package:clock_app/model/alarm_model.dart';
import 'package:clock_app/utils/globals.dart';
import 'package:clock_app/utils/services/alarm_service.dart';
import 'package:clock_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class AlarmDetails extends GetView<AlarmFireController> {
  const AlarmDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var arg = Get.arguments;
    AlarmFireController alarmFireController = Get.put(AlarmFireController());
    alarmFireController.arg(
      int.parse(arg),
    );

    return Scaffold(
      backgroundColor: ThemeColors.darkBgColor2,
      body: controller.obx(
        (state) => Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20.h,
            horizontal: 20.w,
          ),
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: timeWidget(state),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: actionButtons(state),
              ),
            ],
          ),
        ),
        onLoading: const Center(child: CircularProgressIndicator()),
        onEmpty: const Center(child: Text('No Alarms found')),
        onError: (error) => Text(error.toString()),
      ),
    );
  }

  Widget timeWidget(Alarm? alarm) {
    return AvatarGlow(
      // startDelay: const Duration(milliseconds: 1000),
      glowColor: ThemeColors.accentColor,
      endRadius: 190.0,

      duration: const Duration(milliseconds: 2000),
      repeat: true,
      showTwoGlows: true,
      repeatPauseDuration: const Duration(milliseconds: 100),
      child: Container(
        width: 230.w,
        height: 230.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 27, 28, 30),
          border: Border.all(color: ThemeColors.accentColor),
          shape: BoxShape.circle,
        ),
        child: Text(
          alarm!.alarmDateTime,
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.w800,
            color: ThemeColors.accentColor,
            fontFamily: 'Orbitron',
          ),
        ),
      ),
    );
  }

  Widget actionButtons(Alarm? alarm) {
    AlarmController alarmController = Get.put(AlarmController());
    return Row(
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: button(
            label: "SNOOZE",
            onPress: () {
              TimeOfDay timeOfDay = stringToTimeOfDay(alarm!.alarmDateTime);

              DateTime now = DateTime.now();

              DateTime scheduleTime = DateTime(now.year, now.month, now.day,
                      timeOfDay.hour, timeOfDay.minute)
                  .add(const Duration(minutes: 2));

              alarmController
                  .snoozeAlarm(
                alarm.index,
                alarm.alarmId,
                scheduleTime,
              )
                  .whenComplete(() async {
                exit(0);
              });
            },
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          child: button(
            label: "CANCEL",
            onPress: () async {
              if (alarm!.isOnce == 1) {
                alarmController.updateStatus(alarm.index, alarm.alarmId, {
                  "index": alarm.index,
                  "alarmId": alarm.alarmId,
                  "alarmDateTime": alarm.alarmDateTime,
                  "alarmLabel": alarm.alarmLabel,
                  "isActive": 0,
                  "isVibrate": alarm.isVibrate,
                  "isOnce": alarm.isOnce,
                  "isMon": alarm.isMon,
                  "isTue": alarm.isTue,
                  "isWed": alarm.isWed,
                  "isThu": alarm.isThu,
                  "isFri": alarm.isFri,
                  "isSat": alarm.isSat,
                  "isSun": alarm.isSun
                }).whenComplete(() async {
                  // await alarmController.readAlarms();
                  log("app exited");
                  // exit(0);
                });
              } else {
                DateTime now = DateTime.now();
                TimeOfDay timeOfDay = stringToTimeOfDay(alarm.alarmDateTime);
                DateTime scheduleTime = DateTime(now.year, now.month, now.day,
                    timeOfDay.hour, timeOfDay.minute);

                if (alarm.isMon == 1 && scheduleTime.weekday == 1) {
                  scheduleTime.add(
                    const Duration(days: 7),
                  );
                }
                if (alarm.isTue == 1 && scheduleTime.weekday == 2) {
                  scheduleTime.add(
                    const Duration(days: 7),
                  );
                }
                if (alarm.isWed == 1 && scheduleTime.weekday == 3) {
                  scheduleTime.add(
                    const Duration(days: 7),
                  );
                }
                if (alarm.isThu == 1 && scheduleTime.weekday == 4) {
                  scheduleTime.add(
                    const Duration(days: 7),
                  );
                }
                if (alarm.isFri == 1 && scheduleTime.weekday == 5) {
                  scheduleTime.add(
                    const Duration(days: 7),
                  );
                }
                if (alarm.isSat == 1 && scheduleTime.weekday == 6) {
                  scheduleTime.add(
                    const Duration(days: 7),
                  );
                }
                if (alarm.isSun == 1 && scheduleTime.weekday == 7) {
                  await AlarmService.deleteAlarm(alarm.alarmId);
                  await AlarmService.setAlarm(
                    DateTime(now.year, now.month, now.day, timeOfDay.hour,
                            timeOfDay.minute)
                        .add(
                      const Duration(days: 7),
                    ),
                    alarm.alarmId,
                  );
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget button({required String label, required VoidCallback onPress}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          height: 50.h,
          // width: 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.greenAccent,
            ),
            borderRadius: BorderRadius.circular(10.r),
            color: ThemeColors.darkBgColor2,
            boxShadow: [
              const BoxShadow(
                blurRadius: 15,
                spreadRadius: 1,
                offset: Offset(4, 4),
                color: Colors.black,
              ),
              BoxShadow(
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(-4, -4),
                color: Colors.grey.shade800,
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Orbitron',
                color: Colors.greenAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
