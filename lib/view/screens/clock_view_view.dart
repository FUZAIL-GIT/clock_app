// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../controller/clock_view_controller.dart';
import '../widgets/shapes_painter.dart';

class ClockView extends GetView<ClockViewController> {
  const ClockView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ClockViewController clockViewController = Get.put(ClockViewController());
    var now = DateTime.now();
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
            flex: 1,
            child: neumorphismButton(context, clockViewController, height)),
        Flexible(
            flex: height >= 600 && height <= 700 ? 3 : 4,
            child: analogClock(clockViewController, width)),
        Flexible(
            flex: 1, child: digitalClock(now, clockViewController, height)),
        // Flexible(child: timeZone(now)),
      ],
    );
  }

  Widget analogClock(
    ClockViewController clockViewController,
    double width,
  ) {
    return AnimatedBuilder(
      animation: clockViewController.analogClockAnimationController,
      builder: (BuildContext context, Widget? child) {
        return Transform(
          transform: Matrix4.translationValues(
              clockViewController.analogClockAnimation.value * width, 0.0, 0.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomPaint(
              painter: ShapesPainter(),
              child: Container(),
            ),
          ),
        );
      },
    );
  }

  Widget digitalClock(
      DateTime now, ClockViewController clockViewController, double height) {
    var formattedTimeMinute = DateFormat('mm').format(now);
    var formattedTimeseconds = DateFormat('ss').format(now);
    var timePeriod = DateFormat('a').format(now);

    return AnimatedBuilder(
      animation: clockViewController.digitalClockAnimationController,
      builder: (BuildContext context, Widget? child) {
        return Transform(
          transform: Matrix4.translationValues(0.0,
              clockViewController.digitalClockAnimation.value * height, 0.0),
          child: Obx(
            () => GestureDetector(
              onDoubleTap: () {
                clockViewController
                    .changeHourFormat(GetStorage().read('hourFormat'));
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat(GetStorage().read('hourFormat')).format(now),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 55.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Orbitron'),
                      ),
                      Text(
                        ":",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 55.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Orbitron'),
                      ),
                      Text(
                        formattedTimeMinute,
                        style: TextStyle(
                            color: const Color(0xff65D1BA),
                            fontSize: 55.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Orbitron'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              clockViewController.timeString,
                              style: TextStyle(
                                  // color: Color(0xff65D1BA),
                                  color: Colors.white,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Orbitron'),
                            ),
                            Visibility(
                              visible: GetStorage().read('hourFormat') == 'hh',
                              child: Text(
                                timePeriod,
                                style: TextStyle(
                                    color: const Color(0xff65D1BA),
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Orbitron'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Double tap to change the time format",
                    style: TextStyle(fontSize: 10.sp),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget timeZone(DateTime now) {
    var timeZoneString = now.timeZoneOffset.toString().split('.').first;
    var offsetSign = '';
    if (!timeZoneString.startsWith('-')) offsetSign = '+';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.language,
          color: Color(0xff65D1BA),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'UTC$offsetSign$timeZoneString',
            style: const TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget neumorphismButton(BuildContext context,
      ClockViewController clockViewController, double height) {
    var now = DateTime.now();
    var formattedDate = DateFormat('EEE, d MMM').format(now);
    return AnimatedBuilder(
      animation: clockViewController.dateAnimationController,
      builder: (BuildContext context, Widget? child) {
        return Transform(
          transform: Matrix4.translationValues(
              0.0, clockViewController.dateAnimation.value * height, 0.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
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
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.h, vertical: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "TODAY ",
                        style: TextStyle(
                            color: const Color(0xff65D1BA),
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Orbitron'),
                      ),
                      Text(
                        ": ",
                        style: TextStyle(
                            color: const Color(0xff65D1BA),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Orbitron'),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Orbitron'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
