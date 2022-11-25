// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:clock_app/controller/alarm_fired_controller.dart';
import 'package:clock_app/model/alarm_model.dart';
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
        (state) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            timeWidget(state),
            // gestureContainer(),
          ],
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

  Widget actionButtons() {
    return Row(
      children: [
        button(),
      ],
    );
  }

  Widget button() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
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
    );
  }
}
