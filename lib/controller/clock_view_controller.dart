import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class ClockViewController extends GetxController
    with GetTickerProviderStateMixin {
  //animation instance
  int duration = 3;
  late Animation digitalClockAnimation;
  late Animation analogClockAnimation;
  late Animation dateAnimation;
  late AnimationController digitalClockAnimationController;
  late AnimationController analogClockAnimationController;
  late AnimationController dateAnimationController;
  // create some values
  final Rx<Color> _pickerColor = const Color(0xff443a49).obs;
  final Rx<Color> _currentColor = const Color(0xff443a49).obs;
  Color get pickerColor => _pickerColor.value;
  Color get currentColor => _currentColor.value;

  //time String
  final RxString _timeString = ''.obs;
  String get timeString => _timeString.value;

  @override
  void onInit() {
    super.onInit();
    //date animation
    dateAnimationController =
        AnimationController(duration: Duration(seconds: duration), vsync: this);
    dateAnimation = Tween(begin: -0.4, end: 0.0).animate(
      CurvedAnimation(
          parent: dateAnimationController, curve: Curves.fastOutSlowIn),
    );
    dateAnimationController.forward();

    //analog clock animation
    analogClockAnimationController =
        AnimationController(duration: Duration(seconds: duration), vsync: this);
    analogClockAnimation = Tween(begin: -0.6, end: 0.0).animate(
      CurvedAnimation(
          parent: analogClockAnimationController, curve: Curves.fastOutSlowIn),
    );
    analogClockAnimationController.forward();

    //digital clock animation
    digitalClockAnimationController =
        AnimationController(duration: Duration(seconds: duration), vsync: this);
    digitalClockAnimation = Tween(begin: 0.4, end: 0.0).animate(
      CurvedAnimation(
          parent: digitalClockAnimationController, curve: Curves.fastOutSlowIn),
    );
    digitalClockAnimationController.forward();

    //timer
    _timeString.value = _formatDateTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  // ValueChanged<Color> callback
  void changeHourFormat(String value) {
    var localStorage = GetStorage();
    if (value == 'HH') {
      localStorage.write('hourFormat', "hh");
    } else {
      localStorage.write('hourFormat', "HH");
    }
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final RxString formattedDateTime = _formatDateTime(now).obs;
    _timeString.value = formattedDateTime.value;
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('ss').format(dateTime);
  }

  @override
  void onClose() {
    dateAnimationController.dispose();
    digitalClockAnimationController.dispose();
    analogClockAnimationController.dispose();
    super.onClose();
  }
}
