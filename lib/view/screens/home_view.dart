import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import 'alarm_view.dart';
import 'clock_view_view.dart';
import 'stopwatch_view.dart';
import 'timer_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());

    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.h),
            // elevation: 0,
            // backgroundColor: Theme.of(context).primaryColor,
            child: Container(
              color: Colors.grey.shade900,
              child: TabBar(
                padding: const EdgeInsets.all(20),
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xff65D1BA)),
                controller: homeController.tabController,
                indicatorColor: Colors.transparent,
                indicatorWeight: 4.0,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.access_time_rounded),
                  ),
                  Tab(
                    icon: Icon(Icons.alarm_rounded),
                  ),
                  Tab(
                    icon: Icon(Icons.hourglass_empty_rounded),
                  ),
                  Tab(
                    icon: Icon(Icons.timer_rounded),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            color: Theme.of(context).primaryColor,
            child: TabBarView(
              controller: homeController.tabController,
              children: const <Widget>[
                ClockView(),
                AlarmView(),
                TimerView(),
                StopwatchView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget alarmTab() {
    return Column(
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Alarm"),
        )
      ],
    );
  }

  Widget timerTab() {
    return Column(
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Timer"),
        )
      ],
    );
  }
}
