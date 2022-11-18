// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../controller/alarm_controller.dart';
import '../../controller/alarm_fired_controller.dart';

class AlarmDetails extends GetView<AlarmController> {
  const AlarmDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var args = Get.arguments;
    FiredAlarmController firedAlarmController =
        Get.put(FiredAlarmController(alarmId: args));
    return Obx(() {
      var data = firedAlarmController.alarmInfo;

      return controller.obx(
        (state) => Scaffold(
            body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(state![0].alarmLabel),
            Text(state[0].alarmDateTime),
          ],
        )),
        onLoading: const Center(child: CircularProgressIndicator()),
        onEmpty: const Center(child: Text('No Alarms found')),
        onError: (error) => Text(error.toString()),
      );
    });
  }

  Widget showTime(FiredAlarmController firedAlarmController) {
    return Text(firedAlarmController.alarmInfo[0].alarmDateTime);
  }
}
