import 'package:clock_app/controller/alarm_controller.dart';
import 'package:clock_app/utils/services/logging_service.dart';
import 'package:get/get.dart';

import '../model/alarm_model.dart';

class AlarmFireController extends GetxController
    with StateMixin<Alarm>, GetTickerProviderStateMixin {
  late AlarmController alarmController;
  late final RxInt _alarmId = 0.obs;

  void arg(int id) {
    _alarmId.value = id;
  }

  @override
  void onInit() async {
    super.onInit();

    alarmController = Get.put(AlarmController());
    try {
      List<Alarm>? alarm = await alarmController.readAlarms();
      for (var i = 0; i < alarm!.length; i++) {
        if (alarm[i].alarmId == _alarmId.value) {
          change(alarm[i], status: RxStatus.success());

          return;
        }
      }
    } catch (e) {
      talker.error(e);
      change(null, status: RxStatus.error());
    }
  }
}
