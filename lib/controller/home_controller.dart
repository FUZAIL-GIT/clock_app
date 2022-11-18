import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/local_db.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    LocalDatabase.initDb();
    tabController = TabController(length: 4, vsync: this, initialIndex: 0);
  }
}
