// ignore_for_file: unused_local_variable, prefer_if_null_operators

import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../controller/timer_controller.dart';

class TimerView extends GetView<TimerController> {
  const TimerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TimerController timerController = Get.put(TimerController());
    final double height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        timer(timerController, height),
        actionsButton(timerController, context, height),
        // ElevatedButton(
        //   onPressed: () async {
        //     if (timerController.duration.inMinutes == 0) {
        //       Duration? resultingDuration = await showDurationPicker(
        //         context: context,
        //         initialTime: timerController.duration,
        //       );
        //       if (resultingDuration != null) {
        //         Get.snackbar(
        //           'Timer set to',
        //           '${resultingDuration.toString().split('.').first.padLeft(8, "0")}',
        //           colorText: Color(0xff65D1BA),
        //           snackPosition: SnackPosition.BOTTOM,
        //           duration: Duration(seconds: 1),
        //         );
        //       }
        //       timerController.onchange(resultingDuration!);
        //     } else {
        //       timerController.startTimer();
        //     }
        //   },
        //   child: Obx(
        //     () => Text(timerController.duration.inSeconds == 0
        //         ? "Select Duration"
        //         : "Start Timer"),
        //   ),
        // )
      ],
    );
  }

  Widget timer(TimerController timerController, double height) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Obx(() {
        final percentage = (timerController.duration.inSeconds /
            timerController.initialDuration.inSeconds *
            100);

        return AnimatedBuilder(
            animation: timerController.timerAnimationController,
            builder: (BuildContext context, Widget? child) {
              return Transform(
                transform: Matrix4.translationValues(
                    0.0, timerController.timrAnimation.value * height, 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(140.w),
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
                  ),
                  child: CircularPercentIndicator(
                    animationDuration: 1000,
                    animateFromLastPercent: true,
                    animation: true,
                    radius: 140.0.w,
                    percent: timerController.duration.inSeconds == 0
                        ? 0.0
                        : percentage / 100,
                    backgroundColor: const Color(0xff65D1BA),
                    lineWidth: 4,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.white,
                    center: Text(
                      timerController.duration
                          .toString()
                          .split('.')
                          .first
                          .padLeft(8, "0"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.sp,
                        letterSpacing: 0.7,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Orbitron',
                      ),
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }

  Widget resetButton(TimerController timerController) {
    return Obx(() {
      var data = timerController.width;
      return GestureDetector(
          onTap: () async {
            if (timerController.duration.inSeconds > 0 &&
                !timerController.isStarted) timerController.resetTimer();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              height: timerController.height,
              width: timerController.width,
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
              child: const Center(
                child: Text(
                  "RESET",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    letterSpacing: 0.7,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Orbitron',
                  ),
                ),
              ),
            ),
          ));
    });
  }

//button for start and pause
  Widget mainButton(TimerController timerController, double height) {
    return Obx(() {
      var data = timerController.width;
      return AnimatedBuilder(
          animation: timerController.timerButton,
          builder: (BuildContext context, Widget? child) {
            return Transform(
              transform: Matrix4.translationValues(
                  timerController.timerButton.value * height, 0.0, 0.0),
              child: GestureDetector(
                onTap: () async {
                  if (timerController.duration.inMinutes == 0) {
                    Duration? resultingDuration = await showDurationPicker(
                      context: context,
                      initialTime: timerController.duration,
                    );
                    if (resultingDuration!.inSeconds > 0) {
                      timerController.animateContainer(150.w);
                    }

                    // ignore: unnecessary_null_comparison
                    timerController.onchange(resultingDuration != null
                        ? resultingDuration
                        : const Duration(hours: 0, minutes: 0, seconds: 0));
                  } else if (!timerController.isStarted) {
                    timerController.startTimer();
                  } else if (timerController.isStarted) {
                    timerController.stopTimerr();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                    height: timerController.height,
                    width: timerController.width,
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
                    child: Center(
                      child: Obx(() => Text(
                            timerController.duration.inSeconds == 0 &&
                                    !timerController.isStarted
                                ? "Set Time"
                                : !timerController.isStarted &&
                                        !timerController.isPaused &&
                                        timerController.duration.inSeconds > 0
                                    ? "Start"
                                    : timerController.duration.inSeconds > 0 &&
                                            timerController.isStarted
                                        ? "PAUSE"
                                        : timerController.isPaused
                                            ? "RESUME"
                                            : "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              letterSpacing: 0.7,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Orbitron',
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }

  Widget actionsButton(
      TimerController timerController, BuildContext context, double height) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 5.w),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            mainButton(timerController, height),
            Obx(
              () => Visibility(
                visible: timerController.duration.inSeconds > 0 &&
                    !timerController.isStarted &&
                    timerController.isAnimationComplete,
                child: resetButton(timerController),
              ),
            ),
            // neumorphismButton(() async {
            //   if (timerController.duration.inMinutes == 0) {
            //     Duration? resultingDuration = await showDurationPicker(
            //       context: context,
            //       initialTime: timerController.duration,
            //     );
            //     if (resultingDuration != null)
            //       timerController.animateContainer();
            //     Get.snackbar(
            //       'Timer set to',
            //       '${resultingDuration.toString().split('.').first.padLeft(8, "0")}',
            //       colorText: Color(0xff65D1BA),
            //       snackPosition: SnackPosition.TOP,
            //       duration: Duration(seconds: 1),
            //     );

            //     timerController.onchange(resultingDuration != null
            //         ? resultingDuration
            //         : Duration(hours: 0, minutes: 0, seconds: 0));
            //   } else {
            //     timerController.startTimer();
            //   }
            // },
            // timerController.duration.inSeconds == 0
            //     ? "Set Time"
            //     : "Start Timer",
            //     true),
            // if (timerController.duration.inSeconds > 0)
            //   neumorphismButton(() async {}, "Start", true),
          ],
        ));
  }

  Widget neumorphismButton(VoidCallback onTap, String label, bool isMain) {
    TimerController timerController = Get.put(TimerController());

    return GestureDetector(
      onTap: onTap,
      child: Obx(() {
        var isStart = timerController.duration;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: AnimatedContainer(
            duration: const Duration(seconds: 2),
            curve: Curves.fastOutSlowIn,
            height: timerController.height,
            width: timerController.width,
            decoration: BoxDecoration(
              color: const Color(0xff65D1BA),
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    letterSpacing: 0.7,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Orbitron',
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
