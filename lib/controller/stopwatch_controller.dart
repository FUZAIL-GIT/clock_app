import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StopwatchController extends GetxController
    with GetTickerProviderStateMixin {
  final RxDouble _width = 290.w.obs;
  final RxDouble _height = 50.w.obs;
  //animation instance and Controllers declaration
  int animationDuration = 2;
  final listKey = GlobalKey<AnimatedListState>();
  late Animation leftButtonAnimation;
  late Animation rightButtonAnimation;
  late Animation stopWatchRightAnimation;
  late Animation stopWatchLeftAnimation;
  late Animation stopWatchMiddleAnimation;
  late AnimationController leftButtonAnimationController;
  late AnimationController rightButtonAnimationController;
  late AnimationController stopWatchRightAnimationController;
  late AnimationController stopWatchLeftAnimationController;
  late AnimationController stopWatchMiddleAnimationController;

  //variables for stop watch counter
  late Timer timer;
  late Timer nanoTimer;
  final RxBool _isStarted = false.obs;
  final RxBool _isReset = false.obs;
  final RxBool _isAnimationComplete = false.obs;

  final RxList _laps = [].obs;
  final RxInt _seconds = 0.obs;
  final RxInt _minutes = 0.obs;
  final RxInt _hours = 0.obs;

  final RxInt _nanoSeconds = 0.obs;
  final RxString _digitseconds = ''.obs;
  final RxString _digitminutes = ''.obs;
  final RxString _digithours = ''.obs;

  int get second => _seconds.value;
  int get minutes => _minutes.value;
  int get hours => _hours.value;

  String get digitsecond => _digitseconds.value;
  String get digitminutes => _digitminutes.value;
  String get digithours => _digithours.value;

  bool get isStarted => _isStarted.value;
  // ignore: invalid_use_of_protected_member
  List get laps => _laps.value;
  bool get isReset => _isReset.value;
  bool get isAnimationComplete => _isAnimationComplete.value;
  double get width => _width.value;
  double get height => _height.value;
  int get nanoSeconds => _nanoSeconds.value;
  //stop timer function
  void stopTimer() {
    vibrate();
    timer.cancel();
    nanoTimer.cancel();
    _isStarted.value = false;
  }

//animate container
  void animateContainer(double value) {
    _width.value = value;
    if (value == 130.w) {
      Future.delayed(const Duration(milliseconds: 700), () {
        _isAnimationComplete.value = true;
      });
    } else {
      _isAnimationComplete.value = false;
    }
  }

//haptic fedBack
  Future<void> vibrate() async {
    await SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
  }

  //reset timer function
  void resetTimer() {
    vibrate();
    _isReset.value = true;
    animateContainer(320.w);
    _isStarted.value = false;
    timer.cancel();
    _nanoSeconds.value = 0;
    _seconds.value = 0;
    _minutes.value = 0;
    _hours.value = 0;
    _digitseconds.value = '';
    _digitminutes.value = '';
    _digithours.value = '';
    _isStarted.value = false;
    nanoTimer.cancel();
    _laps.value = [];
    // ignore: invalid_use_of_protected_member
    _laps.value.length = 0;
  }

  //add laps function
  void addLaps() {
    // final newindex = 1;
    String lap = "$digithours:$digitminutes:$digitsecond";
    laps.insert(0, lap);
    listKey.currentState!.insertItem(
      0,
      duration: const Duration(milliseconds: 600),
    );
    vibrate();
  }

  //creating the start timer funtion
  void startTimer() {
    _isReset.value = false;
    vibrate();
    animateContainer(130.w);
    _isStarted.value = true;
    nanoTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (_nanoSeconds < 59) {
        _nanoSeconds.value++;
      } else {
        _nanoSeconds.value = 0;
      }
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int localSeconds = _seconds.value + 1;
      int localMinutes = _minutes.value;
      int localHours = _hours.value;
      if (localSeconds > 59) {
        if (localMinutes > 59) {
          localHours++;
          localMinutes = 0;
        } else {
          localMinutes++;
          localSeconds = 0;
        }
      }

      _seconds.value = localSeconds;
      _minutes.value = localMinutes;
      _hours.value = localHours;
      _digitseconds.value =
          (_seconds.value >= 10) ? "${_seconds.value}" : "0${_seconds.value}";

      _digitminutes.value =
          (_minutes.value >= 10) ? "${_minutes.value}" : "0${_minutes.value}";
      _digithours.value =
          (_hours.value >= 10) ? "${_hours.value}" : "0${_hours.value}";
    });
  }

  @override
  void onInit() {
    super.onInit();
    //Right Button Animation
    rightButtonAnimationController = AnimationController(
        duration: Duration(seconds: animationDuration), vsync: this);
    rightButtonAnimation = Tween(begin: -0.4, end: 0.0).animate(
      CurvedAnimation(
          parent: rightButtonAnimationController, curve: Curves.fastOutSlowIn),
    );
    rightButtonAnimationController.forward();

    //Left Button Animation
    leftButtonAnimationController = AnimationController(
        duration: Duration(seconds: animationDuration), vsync: this);
    leftButtonAnimation = Tween(begin: 0.4, end: 0.0).animate(
      CurvedAnimation(
          parent: leftButtonAnimationController, curve: Curves.fastOutSlowIn),
    );
    leftButtonAnimationController.forward();

    //Middle  Stop WatchAnimation
    stopWatchMiddleAnimationController = AnimationController(
        duration: Duration(seconds: animationDuration), vsync: this);
    stopWatchMiddleAnimation = Tween(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(
          parent: stopWatchMiddleAnimationController,
          curve: Curves.fastOutSlowIn),
    );
    stopWatchMiddleAnimationController.forward();
    //Right Stop WatchAnimation
    stopWatchRightAnimationController = AnimationController(
        duration: Duration(seconds: animationDuration), vsync: this);
    stopWatchRightAnimation = Tween(begin: 0.4, end: 0.0).animate(
      CurvedAnimation(
          parent: stopWatchRightAnimationController,
          curve: Curves.fastOutSlowIn),
    );
    stopWatchRightAnimationController.forward();
    //Left Stop WatchAnimation
    stopWatchLeftAnimationController = AnimationController(
        duration: Duration(seconds: animationDuration), vsync: this);
    stopWatchLeftAnimation = Tween(begin: -0.4, end: 0.0).animate(
      CurvedAnimation(
          parent: stopWatchLeftAnimationController,
          curve: Curves.fastOutSlowIn),
    );
    stopWatchLeftAnimationController.forward();
  }

  @override
  void onClose() {
    timer.cancel();
    resetTimer();
    super.onClose();
  }
}
