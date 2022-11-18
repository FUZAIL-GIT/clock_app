// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/stopwatch_controller.dart';

// Choose from any of these available methods

class StopwatchView extends GetView<StopwatchController> {
  const StopwatchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    StopwatchController stopwatchController = Get.put(StopwatchController());
    return Container(
      color: Colors.grey.shade900,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          stopwatch(stopwatchController, height, width),
          Expanded(child: lapList(stopwatchController)),
          startStopButton(stopwatchController, width)
        ],
      ),
    );
  }

  Widget lapList(StopwatchController stopwatchController) {
    return Obx(() => Container(
          color: Colors.grey.shade900,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: AnimatedList(
              key: stopwatchController.listKey,
              initialItemCount: stopwatchController.laps.length,
              itemBuilder: (context, index, animation) {
                return customCard(index, stopwatchController, animation);
              },
            ),
          ),
        ));
  }

  Widget startStopButton(
      StopwatchController stopwatchController, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 30.h,
        horizontal: 10.w,
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: !stopwatchController.isStarted
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            startPauseButton(stopwatchController, width),
            Visibility(
                replacement: stopwatchController.digitsecond != '' &&
                        !stopwatchController.isStarted
                    ? resetbutton(stopwatchController, width)
                    : const SizedBox(),
                visible: stopwatchController.isStarted &&
                    stopwatchController.isAnimationComplete,
                child: lapButton(stopwatchController, width))
          ],
        ),
      ),
    );
  }

//button for start and pause
  Widget startPauseButton(
      StopwatchController stopwatchController, double width) {
    return Obx(() {
      var data = stopwatchController.digithours;
      return AnimatedBuilder(
          animation: stopwatchController.rightButtonAnimationController,
          builder: (BuildContext context, Widget? child) {
            return Transform(
              transform: Matrix4.translationValues(
                  stopwatchController.rightButtonAnimation.value * width,
                  0.0,
                  0.0),
              child: GestureDetector(
                onTap: () {
                  //check if the timr is started or not
                  !stopwatchController.isStarted
                      ? stopwatchController.startTimer()
                      : stopwatchController.stopTimer();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                    height: stopwatchController.height,
                    width: stopwatchController.width,
                    decoration: BoxDecoration(
                      color: !stopwatchController.isStarted
                          ? Colors.grey.shade900
                          : const Color(0xff65D1BA),
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
                            !stopwatchController.isStarted &&
                                    stopwatchController.digitsecond == ''
                                ? "START"
                                : stopwatchController.isStarted
                                    ? "PAUSE"
                                    : !stopwatchController.isStarted &&
                                            stopwatchController.digitsecond !=
                                                ''
                                        ? "RESUME"
                                        : '',
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

//button for reset
  Widget resetbutton(StopwatchController stopwatchController, double width) {
    return Obx(() {
      var data = stopwatchController.digithours;
      return AnimatedBuilder(
          animation: stopwatchController.rightButtonAnimationController,
          builder: (BuildContext context, Widget? child) {
            return Transform(
              transform: Matrix4.translationValues(
                  stopwatchController.rightButtonAnimation.value * width,
                  0.0,
                  0.0),
              child: GestureDetector(
                onTap: () {
                  stopwatchController.resetTimer();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.linear,
                    height: stopwatchController.height,
                    width: stopwatchController.width,
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
                ),
              ),
            );
          });
    });
  }

//button for start and pause
  Widget lapButton(StopwatchController stopwatchController, double width) {
    return AnimatedBuilder(
        animation: stopwatchController.leftButtonAnimationController,
        builder: (BuildContext context, Widget? child) {
          return Transform(
            transform: Matrix4.translationValues(
                stopwatchController.leftButtonAnimation.value * width,
                0.0,
                0.0),
            child: GestureDetector(
              onTap: () {
                stopwatchController.addLaps();
              },
              child: Obx(() {
                var isStart = stopwatchController.isStarted;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Container(
                    height: 50.w,
                    width: 140.w,
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
                        "LAP",
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
                );
              }),
            ),
          );
        });
  }

  Widget customCard(int index, StopwatchController stopwatchController,
      Animation<double> animation) {
    return Obx(() {
      var test = stopwatchController.second;
      return SizeTransition(
        sizeFactor: animation,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: stopwatchController.laps.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(color: Color(0xff65D1BA), width: 0),
                      boxShadow: [
                        const BoxShadow(
                          blurRadius: 7,
                          spreadRadius: 1,
                          offset: Offset(3, 3),
                          color: Colors.black,
                        ),
                        BoxShadow(
                          blurRadius: 7,
                          spreadRadius: 1,
                          offset: const Offset(-3, -3),
                          color: Colors.grey.shade800,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "LAP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontFamily: 'Orbitron',
                          ),
                        ),
                        Text(
                          "${stopwatchController.laps[index]}",
                          style: TextStyle(
                            color: const Color(0xff65D1BA),
                            fontSize: 17.sp,
                            fontFamily: 'Orbitron',
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox()),
      );
    });
  }

  Widget stopwatch(
      StopwatchController stopwatchController, double height, double width) {
    return GestureDetector(
        onDoubleTap: () {
          stopwatchController.addLaps();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 40.h),
          child: Obx(() {
            var data = stopwatchController.isStarted;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    AnimatedBuilder(
                        animation: stopwatchController
                            .stopWatchLeftAnimationController,
                        builder: (BuildContext context, Widget? child) {
                          return Transform(
                            transform: Matrix4.translationValues(
                                stopwatchController
                                        .stopWatchLeftAnimation.value *
                                    width,
                                0.0,
                                0.0),
                            child: Container(
                              width: 90.w,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade900,
                                borderRadius: BorderRadius.circular(10),
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
                                child: Obx(() => Text(
                                      stopwatchController.digitsecond != ''
                                          ? stopwatchController.digithours
                                          : "00",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 35.sp,
                                        letterSpacing: 0.7,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Orbitron',
                                      ),
                                    )),
                              ),
                            ),
                          );
                        }),
                    colon(),
                    AnimatedBuilder(
                        animation: stopwatchController
                            .stopWatchMiddleAnimationController,
                        builder: (BuildContext context, Widget? child) {
                          return Transform(
                            transform: Matrix4.translationValues(
                                0.0,
                                stopwatchController
                                        .stopWatchMiddleAnimation.value *
                                    height,
                                0.0),
                            child: Container(
                              width: 90.w,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade900,
                                borderRadius: BorderRadius.circular(10),
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
                                child: Obx(() => Text(
                                      stopwatchController.digitsecond != ''
                                          ? stopwatchController.digitminutes
                                          : "00",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 35.sp,
                                        letterSpacing: 0.7,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Orbitron',
                                      ),
                                    )),
                              ),
                            ),
                          );
                        }),
                    colon(),
                    AnimatedBuilder(
                        animation: stopwatchController
                            .stopWatchRightAnimationController,
                        builder: (BuildContext context, Widget? child) {
                          return Transform(
                            transform: Matrix4.translationValues(
                                stopwatchController
                                        .stopWatchRightAnimation.value *
                                    width,
                                0.0,
                                0.0),
                            child: Container(
                              width: 90.w,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade900,
                                borderRadius: BorderRadius.circular(10),
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
                                child: Obx(() => Text(
                                      stopwatchController.digitsecond != ''
                                          ? stopwatchController.digitsecond
                                          : "00",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 35.sp,
                                        letterSpacing: 0.7,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Orbitron',
                                      ),
                                    )),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ],
            );
          }),
        ));
  }

  Widget colon() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Text(
        ":",
        style: TextStyle(
          color: const Color(0xff65D1BA),
          fontSize: 35.sp,
          letterSpacing: 0.7,
          fontWeight: FontWeight.bold,
          fontFamily: 'Orbitron',
        ),
      ),
    );
  }

  Widget neumorphismContainer(Widget child) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
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
      child: Center(child: child),
    );
  }

  Widget neumorphismButton(
      BuildContext context, VoidCallback onTap, String label, bool isMain) {
    StopwatchController stopwatchController = Get.put(StopwatchController());

    return GestureDetector(
      onTap: onTap,
      child: Obx(() {
        var isStart = stopwatchController.isStarted;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Container(
            height: 50.w,
            width: 140.w,
            decoration: BoxDecoration(
              color: !isMain
                  ? Colors.grey.shade900
                  : isStart
                      ? const Color(0xff65D1BA)
                      : Colors.grey.shade900,
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
              child: Text(
                isMain && isStart
                    ? "PAUSE"
                    : isMain && !isStart
                        ? "START"
                        : !isMain && !isStart
                            ? "RESET"
                            : "LAP",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 0.7,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Orbitron',
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
