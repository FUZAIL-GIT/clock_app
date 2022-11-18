// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';

import '../model/alarm_model.dart';
import '../utils/local_db.dart';
import '../utils/logger.dart';

class FiredAlarmController extends GetxController
    with StateMixin<List<AlarmInfo>> {
  final String alarmId;
  FiredAlarmController({required this.alarmId});
  final _alarmInfo = <AlarmInfo>[].obs;
  List<AlarmInfo> get alarmInfo => _alarmInfo.value;
  Future<List> readAlarms() async {
    try {
      List<Map<String, Object?>> list = await LocalDatabase.db!.query(
        LocalDatabase.tableName,
        where: 'alarmId= ?',
        whereArgs: [alarmId],
      );

      if (list.isNotEmpty) {
        _alarmInfo.value = list.map((x) => AlarmInfo.fromJson(x)).toList();
        _alarmInfo.refresh();
        change(alarmInfo, status: RxStatus.success());
        talker.good(_alarmInfo[0].alarmDateTime);
      } else if (list.isEmpty) {
        change(null, status: RxStatus.empty());
      }
    } catch (e) {
      talker.error(e);
      change(
        null,
        status: RxStatus.error(
          e.toString(),
        ),
      );
    }

    return alarmInfo;
  }

  @override
  void onInit() {
    readAlarms();
    super.onInit();
  }
}