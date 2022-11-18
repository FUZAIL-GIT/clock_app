import 'dart:async';

import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TimerController extends GetxController with GetTickerProviderStateMixin {
  final RxDouble _width = 300.w.obs;
  final RxDouble _height = 50.w.obs;
  late AnimationController timerAnimationController;
  late AnimationController timerButtonController;
  late Animation timrAnimation;
  late Animation timerButton;

  late Timer timer;
  final RxBool _isStarted = false.obs;
  final RxBool _isAnimationComplete = false.obs;
  final RxBool _isPaused = false.obs;
  bool get isStarted => _isStarted.value;
  bool get isPaused => _isPaused.value;
  late Audio audio;
  final Rx<Duration> _duration =
      const Duration(hours: 0, minutes: 0, seconds: 0).obs;
  final Rx<Duration> _initialDuration =
      const Duration(hours: 0, minutes: 0, seconds: 0).obs;
  Duration get duration => _duration.value;
  double get width => _width.value;
  double get height => _height.value;
  bool get isAnimationComplete => _isAnimationComplete.value;
  Duration get initialDuration => _initialDuration.value;
  void onchange(Duration value) {
    _duration.value = Duration(hours: value.inHours, minutes: value.inMinutes);
    _initialDuration.value = value;
  }

  void stopTimerr() {
    _isPaused.value = true;
    _isStarted.value = false;
    timer.cancel();
    animateContainer(150.w);
  }

  void restartTimer() {
    _duration.value = _initialDuration.value;
    _isStarted.value = true;
    startTimer();
  }

  void animateContainer(double value) {
    _width.value = value;
    if (value == 150.w) {
      Future.delayed(const Duration(milliseconds: 700), () {
        _isAnimationComplete.value = true;
      });
    } else {
      _isAnimationComplete.value = false;
    }
  }

  void resetTimer() {
    // timer.cancel();
    animateContainer(300.w);
    _isPaused.value = false;
    _isStarted.value = false;
    _duration.value = const Duration(hours: 0, minutes: 0, seconds: 0);
  }

  void startTimer() {
    _isStarted.value = true;
    _isPaused.value = false;
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      countDown();
    });
    if (duration.inSeconds > 0) {
      animateContainer(300.w);
    }
  }

  void countDown() {
    const reduceSecondsBy = 1;

    final seconds = _duration.value.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      timer.cancel();
// Play a sound as a one-shot, releasing its resources when it finishes playing.
      audio.play();
      animateContainer(300.w);
      _isStarted.value = false;
      Get.defaultDialog(
        contentPadding: const EdgeInsets.all(40),
        title: "Timer Completed",
        confirmTextColor: const Color(0xff65D1BA),
        cancelTextColor: const Color(0xff65D1BA),
        buttonColor: const Color(0xff65D1BA),
        backgroundColor: Colors.grey.shade800,
        content: Icon(
          Icons.timer_rounded,
          size: 70.w,
        ),
        barrierDismissible: false,
        radius: 10.0,
        confirm: confirmBtn(),
        cancel: cancelBtn(),
      );
    } else {
      _duration.value = Duration(seconds: seconds);
    }
  }

//haptic fedBack
  Future<void> vibrate() async {
    await SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
  }

  @override
  void onInit() {
    super.onInit();

    //Timer WatchAnimation
    timerAnimationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    timrAnimation = Tween(begin: -0.4, end: 0.0).animate(
      CurvedAnimation(
          parent: timerAnimationController, curve: Curves.fastOutSlowIn),
    );
    timerAnimationController.forward();
    //Timer ButtinAnimation
    timerButtonController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    timerButton = Tween(begin: 0.4, end: 0.0).animate(
      CurvedAnimation(
          parent: timerAnimationController, curve: Curves.fastOutSlowIn),
    );
    timerAnimationController.forward();
    // Load from assets, store as a variable.
    audio = Audio.load('assets/audio/timer_notifier.wav');
  }
}

Widget confirmBtn() {
  TimerController timerController = Get.put(TimerController());

  return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color(0xff65D1BA),
        ),
      ),
      onPressed: () {
        timerController.audio.pause();
        Get.back();
      },
      child: const Text("Complete"));
}

Widget cancelBtn() {
  TimerController timerController = Get.put(TimerController());
  return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color(0xff65D1BA),
        ),
      ),
      onPressed: () {
        timerController.restartTimer();
        timerController.audio.pause();
        timerController.animateContainer(150.w);
        Get.back();
      },
      child: const Text("Restart"));
}
