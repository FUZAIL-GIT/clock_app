// ignore_for_file: invalid_use_of_protected_member, unused_element
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:clock_app/utils/services/alarm_service.dart';
import 'package:clock_app/utils/services/battery_optimization_service.dart';
import 'package:clock_app/utils/services/local_notification_service.dart';
import 'package:clock_app/utils/services/local_storage_service.dart';
import 'package:clock_app/view/screens/home_view.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../model/alarm_model.dart';
import '../utils/globals.dart';
import '../utils/services/logging_service.dart';

class AlarmController extends GetxController with StateMixin<List<Alarm>> {
  final formkKey = GlobalKey<FormState>();
  TextEditingController alarmLabel = TextEditingController();
  final RxInt _daysCount = 0.obs;
  final Rx<TimeOfDay> _selectedTime = TimeOfDay.now().obs;
  late FlutterRingtonePlayer flutterRingtonePlayer;
  BatteryOptimizationController batteryOptimizationController =
      Get.put(BatteryOptimizationController());
  // final RxBool _isBatteryOptimizationDisabled = false.obs;

  final RxBool _isVibrate = true.obs;
  // RxList<AlarmInfo> _alarmInfo = (List<AlarmInfo>.of([])).obs;
  final _alarmInfo = <Alarm>[].obs;
  final RxBool _isActive = true.obs;

  final RxInt _isOnce = 1.obs;
  final RxInt _isMon = 0.obs;
  final RxInt _isTue = 0.obs;
  final RxInt _isWed = 0.obs;
  final RxInt _isThu = 0.obs;
  final RxInt _isFri = 0.obs;
  final RxInt _isSat = 0.obs;
  final RxInt _isSun = 0.obs;

  List<Alarm> get alarmInfo => _alarmInfo.value;

  int get isOnce => _isOnce.value;
  int get isMon => _isMon.value;
  int get isTue => _isTue.value;
  int get isWed => _isWed.value;
  int get isThu => _isThu.value;
  int get isFri => _isFri.value;
  int get isSat => _isSat.value;
  int get isSun => _isSun.value;

  int get daysCount => _daysCount.value;

  // bool get isBatteryOptimizationDisabled =>
  //     _isBatteryOptimizationDisabled.value;

  bool get isVibrate => _isVibrate.value;

  bool get isActive => _isActive.value;

  TimeOfDay get selectedTime => _selectedTime.value;

  void increaseNoOfDays() {
    _daysCount.value++;
  }

  void setPreviousValues(
    String dateTime,
    String label,
    int isOnce,
    int isVibrate,
    int isMon,
    int isTue,
    int isWed,
    int isThu,
    int isFri,
    int isSat,
    int isSun,
    int alarmId,
  ) async {
    _selectedTime.value = stringToTimeOfDay(dateTime);
    alarmLabel.text = label;
    _isVibrate.value = isVibrate == 1 ? true : false;
    _isOnce.value = isOnce;
    _isMon.value = isMon;
    _isTue.value = isTue;
    _isWed.value = isWed;
    _isThu.value = isThu;
    _isFri.value = isFri;
    _isSat.value = isSat;
    _isSun.value = isSun;
  }

//onchange
  void isActiveOnChange(bool value) {
    _isVibrate.value = value;
  }

// Select for Time
  void pickTime(BuildContext context) async {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: _selectedTime.value,
        onChange: (value) {
          _selectedTime.value = value;
        },
        is24HrFormat: GetStorage().read('hourFormat') == 'hh' ? false : true,
      ),
    );
  }

//selectDay
  void onSelectDay(String label, int value) {
    talker.log("$label $value");
    if (label == 'isOnce') {
      _isOnce.value = value;
      if (value == 1) {
        _isMon.value = 0;
        _isTue.value = 0;
        _isWed.value = 0;
        _isThu.value = 0;
        _isFri.value = 0;
        _isSat.value = 0;
        _isSun.value = 0;
      }
    } else if (label == 'isMon') {
      _isOnce.value = 0;
      _isMon.value = value;
    } else if (label == 'isTue') {
      _isOnce.value = 0;
      _isTue.value = value;
    } else if (label == 'isWed') {
      _isOnce.value = 0;
      _isWed.value = value;
    } else if (label == 'isThu') {
      _isOnce.value = 0;
      _isThu.value = value;
    } else if (label == 'isFri') {
      _isOnce.value = 0;
      _isFri.value = value;
    } else if (label == 'isSat') {
      _isOnce.value = 0;
      _isSat.value = value;
    } else if (label == 'isSun') {
      _isOnce.value = 0;
      _isSun.value = value;
    }
  }

//delete alarm
  void deleteAlarm(int index, int alarmId) async {
    try {
      await AlarmService.deleteAlarm(alarmId);
      LocalStorage.deleteAlarm(index).whenComplete(() async {
        talker.good("AlarmInfo Removed From Local Database (index : $index)");
        _alarmInfo.refresh();
        await readAlarms();
        Get.to(
          const HomeView(),
          transition: Transition.circularReveal,
          curve: Curves.bounceOut,
          duration: const Duration(seconds: 2),
        );
        Get.delete<AlarmController>();
      });
    } catch (e) {
      talker.error(e);
    }
  }

//activate de-activate alarm
  Future<void> updateStatus(int index, int alarmId, var model) async {
    await LocalStorage.updateAlarmStatus(index, alarmId, model)
        .whenComplete(() async {
      _alarmInfo.refresh();
      await readAlarms();
      Get.to(
        const HomeView(),
        transition: Transition.circularReveal,
        curve: Curves.bounceOut,
        duration: const Duration(seconds: 2),
      );
      Get.delete<AlarmController>();
    });
  }

//Submit data
  Future<bool> submitData() async {
    DateTime now = DateTime.now();
    DateTime scheduleTime = DateTime(now.year, now.month, now.day,
        _selectedTime.value.hour, _selectedTime.value.minute);
    int alarmId = Random().nextInt(pow(2, 31) as int);
    List<Alarm>? alarms = await readAlarms();

//submit the data to the local data base
    await LocalStorage.createAlarm(
      index: alarms != null ? alarms.length : 0,
      alarmId: alarmId,
      alarmDateTime: _selectedTime.value,
      alarmLabel: alarmLabel.text.toString(),
      isActive: _isActive.value == true ? 1 : 0,
      isVibrate: _isVibrate.value == true ? 1 : 0,
      isOnce: _isOnce.value,
      isMon: _isMon.value,
      isTue: _isTue.value,
      isWed: _isWed.value,
      isThu: _isThu.value,
      isFri: _isFri.value,
      isSat: _isSat.value,
      isSun: _isSun.value,
    );
    //create alarm
    await AlarmService.setAlarm(scheduleTime, alarmId);
    return true;
  }

  Future<void> updateAlarm(int index, int alarmId) async {
    await LocalStorage.updateAlarm(index, alarmId, {
      "index": index,
      "alarmId": alarmId,
      "alarmDateTime": timeOfDaytoString(_selectedTime.value),
      "alarmLabel": alarmLabel.text.toString(),
      "isActive": _isActive.value == true ? 1 : 0,
      "isVibrate": _isVibrate.value == true ? 1 : 0,
      "isOnce": _isOnce.value,
      "isMon": _isMon.value,
      "isTue": _isTue.value,
      "isWed": _isWed.value,
      "isThu": _isThu.value,
      "isFri": _isFri.value,
      "isSat": _isSat.value,
      "isSun": _isSun.value,
    });
  }

  Future<void> snoozeAlarm(int index, int alarmId, DateTime dateTime) async {
    TimeOfDay timeOfDay =
        TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    await LocalStorage.updateAlarm(index, alarmId, {
      "index": index,
      "alarmId": alarmId,
      "alarmDateTime": timeOfDaytoString(timeOfDay),
      "alarmLabel": alarmLabel.text.toString(),
      "isActive": _isActive.value == true ? 1 : 0,
      "isVibrate": _isVibrate.value == true ? 1 : 0,
      "isOnce": _isOnce.value,
      "isMon": _isMon.value,
      "isTue": _isTue.value,
      "isWed": _isWed.value,
      "isThu": _isThu.value,
      "isFri": _isFri.value,
      "isSat": _isSat.value,
      "isSun": _isSun.value,
    }).whenComplete(
      () => talker.log("Alarm Snoozed for 2 minutes"),
    );
  }

//read Alarms from the Local Database
  Future<List<Alarm>?> readAlarms() async {
    try {
      var alarmInfo = await LocalStorage.readAlarm();

      if (alarmInfo != null) {
        _alarmInfo.refresh();

        change(alarmInfo, status: RxStatus.success());
        return alarmInfo;
      } else if (alarmInfo == null) {
        change(null, status: RxStatus.empty());
        // return null;
      }
    } on FileSystemException catch (e) {
      if (e.osError != null) {
        change(null, status: RxStatus.empty());
      }
      // change(
      //   null,
      //   status: RxStatus.error(
      //     e.toString(),
      //   ),
      // );
      talker.error(e);
    }
    return null;
  }

  @override
  void onInit() async {
    super.onInit();
    // await LocalStorage.init();
    LocalNotification.init();
    LocalNotification.listenNotification();

    await readAlarms();
  }
}
