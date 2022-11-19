import 'package:flutter/material.dart';

class LifeCycleListener extends WidgetsBindingObserver {
  // LifeCycleListener();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        print("ap mini $state");

        // saveAlarms();
        break;
      case AppLifecycleState.resumed:
        // createAlarmPollingIsolate();
        break;
      default:
        print("Updated lifecycle state: $state");
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
