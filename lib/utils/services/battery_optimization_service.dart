import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:get/get.dart';

class BatteryOptimizationController extends GetxController {
  final RxBool _isBatteryOptimizationDisabled = false.obs;
  bool get isBatteryOptimizationDisabled =>
      _isBatteryOptimizationDisabled.value;
  Future<void> isBatteryOptimizationEnable() async {
    _isBatteryOptimizationDisabled.value =
        (await DisableBatteryOptimization.isAllBatteryOptimizationDisabled)!;
  }

  @override
  void onInit() async {
    super.onInit();
    _isBatteryOptimizationDisabled.value =
        (await DisableBatteryOptimization.isBatteryOptimizationDisabled)!;
    if (!isBatteryOptimizationDisabled) {
      DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
    }
  }
}
