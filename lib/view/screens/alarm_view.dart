// ignore_for_file: unused_local_variable, unused_element

import 'dart:developer';

import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../controller/alarm_controller.dart';
import '../../model/alarm_model.dart';
import '../../utils/local_db.dart';
import '../../utils/logger.dart';
import 'alarm_post_view.dart';

class AlarmView extends GetView<AlarmController> {
  const AlarmView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //controller instance
    AlarmController alarmController = Get.put(AlarmController());

    return Obx(() {
      var data = alarmController.isActive;
      return RefreshIndicator(
        onRefresh: () {
          return alarmController.readAlarms();
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade900,
          body: controller.obx(
            (state) => Visibility(
              visible: alarmController.isBatteryOptimizationDisabled,
              replacement: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    DisableBatteryOptimization
                        .showDisableBatteryOptimizationSettings();
                    alarmController.updateValue();
                  },
                  child: const Text("Disable Battery Optimization"),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: alarmList(alarmController, state),
                  ),
                ],
              ),
            ),
            onLoading: const Center(child: CircularProgressIndicator()),
            onEmpty: const Center(child: Text('No Alarms found')),
            onError: (error) => Text(error.toString()),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              // Delete a record
              // LocalDatabase.db!.delete(
              //   LocalDatabase.tableName,
              //   where: 'id= ?',
              //   whereArgs: ['1'],
              // );

              // List<Map<String, Object?>> list =
              //     await LocalDatabase.db!.query(LocalDatabase.tableName);

              // talker.log(list);
              // alarmController.deletedb();
              // alarmController.readAlarms();
              // AlarmController.playAlarm();

              Get.to(
                const AlarmPostView(),
                transition: Transition.circularReveal,
                curve: Curves.bounceIn,
                duration: const Duration(seconds: 1),
              );
            },
            label: const Text('Add Alarm'),
            icon: const Icon(
              Icons.add_alarm_rounded,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }

  Widget alarmList(
      AlarmController alarmController, List<AlarmInfo>? alarmInfo) {
    return Obx(() {
      var data = alarmController.alarmInfo.length;
      log(
        alarmController.alarmInfo.length.toString(),
      );
      return ListView.builder(
        itemCount: alarmInfo!.length,
        itemBuilder: (context, index) {
          return alarmCard(alarmInfo, index, alarmController);
        },
      );
    });
  }

  Widget alarmCard(
      List<AlarmInfo>? alarmInfo, int index, AlarmController alarmController) {
    List<String> listOfDays() {
      List daysName = [
        {"dayNum": alarmInfo![index].isOnce, "dayName": "Once"},
        {"dayNum": alarmInfo[index].isMon, "dayName": "Mon"},
        {"dayNum": alarmInfo[index].isTue, "dayName": "Tue"},
        {"dayNum": alarmInfo[index].isWed, "dayName": "Wed"},
        {"dayNum": alarmInfo[index].isThu, "dayName": "Thu"},
        {"dayNum": alarmInfo[index].isFri, "dayName": "Fri"},
        {"dayNum": alarmInfo[index].isSat, "dayName": "Sat"},
        {"dayNum": alarmInfo[index].isSun, "dayName": "Sun"},
      ];
      List<String> daysList = [];
      for (var i = 0; i <= 7; i++) {
        if (daysName[i]["dayNum"] == 1) {
          daysList.add(daysName[i]["dayName"]);
        }
      }
      return daysList;
    }

    return GestureDetector(
      onLongPress: () {
        alarmController.activeUpdate(
            0, alarmInfo[index].id!, alarmInfo[index].alarmId);
        // Delete a record
        LocalDatabase.db!.delete(
          LocalDatabase.tableName,
          where: 'id= ?',
          whereArgs: [alarmInfo[index].id],
        ).whenComplete(() async {
          await alarmController.readAlarms();
          talker.error("Delete Alarm");
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          // height: 100.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            boxShadow: [
              const BoxShadow(
                blurRadius: 10,
                spreadRadius: 1,
                offset: Offset(2, 2),
                color: Colors.black,
              ),
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(-2, -2),
                color: Colors.grey.shade800,
              ),
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.label,
                        color: const Color(0xff65D1BA),
                        size: 24.sp,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        alarmInfo![index].alarmLabel,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Orbitron',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.7,
                          fontSize: 17.sp,
                        ),
                      ),
                    ],
                  ),
                  Obx(() {
                    var data = alarmController.isActive;
                    return Switch(
                      value: alarmInfo[index].isActive == 1 ? true : false,
                      onChanged: (bool value) {
                        alarmController.activeUpdate(value == true ? 1 : 0,
                            alarmInfo[index].id!, alarmInfo[index].alarmId);
                      },
                    );
                  })
                ],
              ),
              SizedBox(
                height: 20,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listOfDays().length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 5.w),
                        child: Row(
                          children: [
                            Text(
                              listOfDays()[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Orbitron',
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0.7,
                                fontSize: 12.sp,
                              ),
                            ),
                            Text(
                              index != listOfDays().length - 1 ? "," : '',
                              style: TextStyle(
                                color: const Color(0xff65D1BA),
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),

              // Text(
              //   noOfDays(),
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontFamily: 'Orbitron',
              //     fontWeight: FontWeight.normal,
              //     letterSpacing: 0.7,
              //     fontSize: 15.sp,
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    alarmInfo[index].alarmDateTime,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Orbitron',
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0.7,
                      fontSize: 15.sp,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.to(
                          const AlarmPostView(),
                          arguments: [
                            alarmInfo[index].alarmDateTime,
                            alarmInfo[index].alarmLabel,
                            alarmInfo[index].isOnce,
                            alarmInfo[index].isVibrate,
                            alarmInfo[index].isMon,
                            alarmInfo[index].isTue,
                            alarmInfo[index].isWed,
                            alarmInfo[index].isThu,
                            alarmInfo[index].isFri,
                            alarmInfo[index].isSat,
                            alarmInfo[index].isSun,
                            alarmInfo[index].id,
                            alarmInfo[index].alarmId,
                          ],
                          transition: Transition.circularReveal,
                          curve: Curves.bounceOut,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 25.sp,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
