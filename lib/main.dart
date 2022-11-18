// ignore_for_file: deprecated_member_use

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:clock_app/utils/logger.dart';
import 'package:clock_app/view/screens/home_view.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final FlutterLocalNotificationsPlugin flutterLocalNitificationPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // Very important to call before initialize since it
  // ensures the binding is available and ready before
  // any native call
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  tz.initializeTimeZones();
  //initial GetStorage bucket
  await GetStorage.init();
  //write data if the data was null it may prevent error from first time app run
  GetStorage().writeIfNull('hourFormat', 'hh');
  talker.info('App is started');
  runApp(DevicePreview(
    enabled: false,
    builder: (context) => ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) {
          return GetMaterialApp(
            title: "Application",
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark(),
            home: const HomeView(),
            // getPages: [GetPage(name: "name", page: page)],
          );
        }),
  ));
}
