// ignore_for_file: invalid_use_of_protected_member, unused_element

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../../main.dart';
import '../model/alarm_model.dart';
import '../utils/globals.dart';
import '../utils/local_db.dart';
import '../utils/logger.dart';
import '../view/screens/alarmdetails_view.dart';

class AlarmController extends GetxController with StateMixin<List<AlarmInfo>> {
  final forkKey = GlobalKey<FormState>();
  TextEditingController alarmLabel = TextEditingController();
  final RxInt _daysCount = 0.obs;
  final Rx<TimeOfDay> _selectedTime = TimeOfDay.now().obs;
  late FlutterRingtonePlayer flutterRingtonePlayer;

  final RxBool _isBatteryOptimizationDisabled = false.obs;

  final RxBool _isVibrate = true.obs;
  // RxList<AlarmInfo> _alarmInfo = (List<AlarmInfo>.of([])).obs;
  final _alarmInfo = <AlarmInfo>[].obs;
  final RxBool _isActive = true.obs;

  final RxInt _isOnce = 1.obs;
  final RxInt _isMon = 0.obs;
  final RxInt _isTue = 0.obs;
  final RxInt _isWed = 0.obs;
  final RxInt _isThu = 0.obs;
  final RxInt _isFri = 0.obs;
  final RxInt _isSat = 0.obs;
  final RxInt _isSun = 0.obs;

  List<AlarmInfo> get alarmInfo => _alarmInfo.value;

  int get isOnce => _isOnce.value;
  int get isMon => _isMon.value;
  int get isTue => _isTue.value;
  int get isWed => _isWed.value;
  int get isThu => _isThu.value;
  int get isFri => _isFri.value;
  int get isSat => _isSat.value;
  int get isSun => _isSun.value;

  int get daysCount => _daysCount.value;

  bool get isBatteryOptimizationDisabled =>
      _isBatteryOptimizationDisabled.value;

  bool get isVibrate => _isVibrate.value;

  bool get isActive => _isActive.value;

  static final onNotifications = BehaviorSubject<String?>();

  TimeOfDay get selectedTime => _selectedTime.value;

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        sound: UriAndroidNotificationSound(
            "assets/sound_effects/timer_notifier.wav"),
        enableLights: true,
        color: Color(0xff65D1BA),
        ledColor: Color(0xff65D1BA),
        ledOnMs: 1000,
        ledOffMs: 500,
        playSound: true,
        priority: Priority.high,
      ),
    );
  }

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
    int id,
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

  void activeUpdate(int value, int id, int alarmIId) async {
    _isActive.value = value == 1 ? true : false;
    Map<String, dynamic> row = {
      "id": id,
      "isActive": value,
    };
    await AndroidAlarmManager.cancel(alarmIId);
    await LocalDatabase.db!.update(
      LocalDatabase.tableName,
      row,
      where: 'id= ?',
      whereArgs: [id],
    ).whenComplete(() async {
      await readAlarms();
      talker.good("Alarm is : ${value == 1 ? "Activated" : "De-Activated "}");
    });
  }

//!update the alarm in sqf lite
  Future<void> updateData(int alarmId, int id) async {
    AlarmInfo model = AlarmInfo(
      id: id,
      alarmId: alarmId,
      alarmDateTime: formatTimeOfDay(_selectedTime.value),
      alarmLabel: alarmLabel.text,
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

    await LocalDatabase.db!.update(
      LocalDatabase.tableName,
      model.toJson(),
      where: 'id= ?',
      whereArgs: [id],
    );
  }

  static Future init({bool initScheduled = false}) async {
    //android initializationSettingAndroid
    var initializationSettingAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

//IOS initializationSettingIOS
    var initializationSettingIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int? id, String? title, String? body, String? payload) async {});

//initializationSetting
    var initializationSettings = InitializationSettings(
        android: initializationSettingAndroid, iOS: initializationSettingIOS);

//initialization
    await flutterLocalNitificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (notificationResponse.payload != null) {
        onNotifications.add(payload);
      }
    });
  }

//!simple notification
  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async =>
      flutterLocalNitificationPlugin.show(
          id, title, body, await _notificationDetails(),
          payload: payLoad);

//!schedule notification
  Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
    required DateTime scheduledDate,
  }) async {
    await flutterLocalNitificationPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        await _notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
    // audio.play();
  }

  void updateValue() async {
    _isBatteryOptimizationDisabled.value =
        (await DisableBatteryOptimization.isBatteryOptimizationDisabled)!;
  }

//!set the alarm in android alarm manager
  void setAlarm(DateTime scheduleTime, int alarmId) async {
    talker.info("setAlarm on :$scheduleTime");
    // final int alarmID = 1;
    // final DateTime scheduleTime = DateTime.now().add(Duration(seconds: 5));
    await AndroidAlarmManager.oneShotAt(
      scheduleTime,
      alarmId,
      playAlarm,
      rescheduleOnReboot: true,
      wakeup: true,
      exact: true,
      alarmClock: true,
    );
  }

//!onchange
  void isActiveOnChange(bool value) {
    _isVibrate.value = value;
  }

  // static List<Map<String, Object?>> list = [];
  // static void loadDatabase() async {
  //   // try {
  //   list = await LocalDatabase.db!.query(LocalDatabase.tableName);
  //   talker.log(list);
  //   //} catch (e) {
  //   // talker.error(e);
  //   //}
  // }
  static Future<void> readlocaldb(String alarmId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;

      final file = File('$path/$alarmId.txt');
      final contents = await file.readAsString();
      AlarmInfo alarmDetails = AlarmInfo.fromJson(jsonDecode(contents));
      showNotification(
          body: alarmDetails.alarmDateTime,
          title: alarmDetails.alarmLabel,
          payLoad: alarmDetails.alarmId.toString());
      // talker.log(result.alarmLabel);
    } catch (e) {
      talker.error(e);
    }
  }

  static void alarmMedia() async {
    final Iterable<Duration> pauses = [
      const Duration(milliseconds: 500),
      const Duration(milliseconds: 1000),
      const Duration(milliseconds: 500),
      const Duration(milliseconds: 1000),
      const Duration(milliseconds: 500),
      const Duration(milliseconds: 1000),
      const Duration(milliseconds: 500),
      const Duration(milliseconds: 1000),
      const Duration(milliseconds: 500),
      const Duration(milliseconds: 1000),
      const Duration(milliseconds: 500),
    ];

    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.vibrateWithPauses(pauses);
    }
    FlutterRingtonePlayer.play(
      android: AndroidSounds.alarm,

      ios: IosSounds.glass,
      looping: false, // Android only - API >= 28
      volume: 10, // Android only - API >= 28
      asAlarm: true, // Android only - all APIs
    );
  }

//!play alarm
  static void playAlarm(int alarmId) async {
    Future.delayed(const Duration(seconds: 1), () async {
      await readlocaldb(alarmId.toString());
    });
    alarmMedia();
    talker.log("ID : $alarmId");

    // if (Platform.isAndroid) {
    //   restartApp();
    //   Timer(const Duration(seconds: 5), () {
    //     Bringtoforeground.bringAppToForeground();
    //   });
    //   return;
    // }
    // Timer(Duration(seconds: 5), () {
    //   Bringtoforeground.bringAppToForeground();
    // });

    // showNotification(body: 'One shot alarm at', title: 'Alarm Manager');

    // talker.log(list.length);
  }

//! Select for Time
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

//!selectDay
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

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    talker.info("Local Storage Directory :  ${directory.path}");

    return directory.path;
  }

  Future<File> localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName.txt');
  }

  Future submit(int alarmId) async {
    final file = await localFile(alarmId.toString());

    AlarmInfo model = AlarmInfo(
      alarmId: alarmId,
      alarmDateTime: formatTimeOfDay(_selectedTime.value),
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
    file.writeAsString(jsonEncode(model));
  }

//!Submit data
  Future<void> submitData() async {
    DateTime now = DateTime.now();
    DateTime scheduleTime = DateTime(now.year, now.month, now.day,
        _selectedTime.value.hour, _selectedTime.value.minute);
    int alarmId = Random().nextInt(pow(2, 31) as int);
    await submit(alarmId);
    setAlarm(scheduleTime, alarmId);
    AlarmInfo model = AlarmInfo(
      alarmId: alarmId,
      alarmDateTime: formatTimeOfDay(_selectedTime.value),
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

    await LocalDatabase.db!
        .insert(
      LocalDatabase.tableName,
      model.toJson(),
    )
        .whenComplete(
      () async {
        await readAlarms();
        talker.good("Date inserted Successfully");
      },
    );
  }

//!delete alarm
  void deletedb() async {
    String path = '${await getDatabasesPath()}alarm_info.db';
    await deleteDatabase(path).whenComplete(
      () async {
        Vibrate.vibrate();
        talker.error("DataBase Deleted");
      },
    );
  }

  Future<List<AlarmInfo>> readAlarms() async {
    try {
      List<Map<String, Object?>> list =
          await LocalDatabase.db!.query(LocalDatabase.tableName);

      if (list.isNotEmpty) {
        _alarmInfo.value = list.map((x) => AlarmInfo.fromJson(x)).toList();
        _alarmInfo.refresh();
        change(alarmInfo, status: RxStatus.success());
        talker.good("Alarm List Lenght : ${_alarmInfo.value.length}");
//         for (int i = 0; i < list.length; i++) {
//           talker.good('''\n
//           Alarm IndexNo : ${_alarmInfo.value[i].id}
//           Alarm Id : ${_alarmInfo.value[i].alarmId}
//           Alarm Label : ${_alarmInfo.value[i].alarmLabel}
//           Alarm Time : ${_alarmInfo.value[i].alarmDateTime}
//           Alarm isActive : ${_alarmInfo.value[i].isActive}
//           Alarm isOnce : ${_alarmInfo.value[i].isOnce}
//           Alarm isMon : ${_alarmInfo.value[i].isMon}
//           Alarm isTue : ${_alarmInfo.value[i].isTue}
//           Alarm isWed : ${_alarmInfo.value[i].isWed}
//           Alarm isThu : ${_alarmInfo.value[i].isThu}
//           Alarm isFri : ${_alarmInfo.value[i].isFri}
//           Alarm isSat : ${_alarmInfo.value[i].isSat}
//           Alarm isSun : ${_alarmInfo.value[i].isSun}

// ''');
//         }
      } else if (list.isEmpty) {
        change(null, status: RxStatus.empty());
      }
    } catch (e) {
      change(
        null,
        status: RxStatus.error(
          e.toString(),
        ),
      );
      talker.error(e);
    }

    return alarmInfo;
  }

  @override
  void onInit() async {
    super.onInit();
    init();
    listenNotification();
    //initial sqflite database

    readAlarms();
    _isBatteryOptimizationDisabled.value =
        (await DisableBatteryOptimization.isBatteryOptimizationDisabled)!;
    if (!_isBatteryOptimizationDisabled.value) {
      DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
    }
  }

  void listenNotification() =>
      onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) {
    talker.log("Notification Clicked");
    talker.log(payload);
    FlutterRingtonePlayer.stop();
    Get.to(const AlarmDetails(), arguments: payload);
  }
}
