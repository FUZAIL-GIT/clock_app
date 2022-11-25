import 'package:clock_app/utils/services/logging_service.dart';
import 'package:flutter/material.dart';

class LifeCycleListener extends WidgetsBindingObserver {
  // LifeCycleListener();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        talker.log("App Minimize $state");

        // saveAlarms();
        break;
      case AppLifecycleState.detached:
        talker.log("App Terminated $state");
        break;
      case AppLifecycleState.resumed:
        // createAlarmPollingIsolate();
        break;
      default:
        talker.log("App Resumed $state");
    }
  }

  // void saveAlarms() {
  //   alarms.alarms.forEach((alarm) => alarm.updateMusicPaths());
  //   JsonFileStorage().writeList(alarms.alarms);
  // }

  // void createAlarmPollingIsolate() {
  //   print('Creating a new worker to check for alarm files!');
  //   AlarmPollingWorker().createPollingWorker();
  // }
}
