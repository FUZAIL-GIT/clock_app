import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../view/screens/alarmdetails_view.dart';
import 'logging_service.dart';

class LocalNotification {
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

  static final onNotifications = BehaviorSubject<String?>();
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
    required int id,
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

  static void listenNotification() =>
      onNotifications.stream.listen(onClickedNotification);

  static void onClickedNotification(String? payload) {
    talker.log("Notification Clicked");
    talker.log(payload);
    FlutterRingtonePlayer.stop();
    Get.to(const AlarmDetails(), arguments: payload);
  }
}
