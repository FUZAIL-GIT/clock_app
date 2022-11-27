// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../controller/alarm_controller.dart';
import 'home_view.dart';

class AlarmPostView extends GetView {
  const AlarmPostView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AlarmController alarmController = AlarmController();
    var args = Get.arguments;
    if (args != null) {
      alarmController.setPreviousValues(
        args[0],
        args[1],
        args[2],
        args[3],
        args[4],
        args[5],
        args[6],
        args[7],
        args[8],
        args[9],
        args[10],
        args[11],
      );
    }
    return Form(
      key: alarmController.formkKey,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey.shade900,
          appBar: AppBar(
            title: const Text('AlarmPostView'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.grey.shade900,
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Get.to(
                  const HomeView(),
                  transition: Transition.circularReveal,
                  curve: Curves.decelerate,
                  duration: const Duration(seconds: 1),
                );
              },
              // ignore: deprecated_member_use
              icon: const Icon(Icons.arrow_back),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (alarmController.formkKey.currentState!.validate()) {
                    args == null
                        ? alarmController.submitData().whenComplete(() {
                            Get.to(
                              const HomeView(),
                              transition: Transition.circularReveal,
                              curve: Curves.bounceOut,
                              duration: const Duration(seconds: 2),
                            );
                            Get.delete<AlarmController>();
                          })
                        : alarmController
                            .updateAlarm(
                            args[11],
                            args[12],
                          )
                            .whenComplete(() {
                            Get.to(
                              const HomeView(),
                              transition: Transition.circularReveal,
                              curve: Curves.bounceOut,
                              duration: const Duration(seconds: 2),
                            );
                            Get.delete<AlarmController>();
                          });

                    await alarmController.readAlarms();
                  }
                },
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Color(0xff65D1BA),
                    fontFamily: 'Orbitron',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 20.h,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 15.h,
                ),
                labelText(alarmController),
                SizedBox(
                  height: 29.h,
                ),
                timePicker(
                  alarmController,
                  context,
                ),
                SizedBox(
                  height: 20.h,
                ),
                optionBtns(alarmController),
                SizedBox(
                  height: 20.h,
                ),
                daySelector(alarmController),
                const Spacer(),
              ],
            ),
          )),
    );
  }

  Widget daySelector(AlarmController alarmController) {
    return Obx(() {
      // ignore: unused_local_variable
      var data = alarmController.isActive;
      return GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        childAspectRatio: 1 / 0.5,
        children: [
          container(() {
            alarmController.onSelectDay(
                "isOnce", alarmController.isOnce == 1 ? 0 : 1);
          }, 'Once',
              alarmController.isOnce == 1 ? Colors.greenAccent : Colors.white),
          container(() {
            alarmController.onSelectDay(
                "isMon", alarmController.isMon == 1 ? 0 : 1);
          }, 'Mon',
              alarmController.isMon == 1 ? Colors.greenAccent : Colors.white),
          container(() {
            alarmController.onSelectDay(
                "isTue", alarmController.isTue == 1 ? 0 : 1);
          }, 'Tue',
              alarmController.isTue == 1 ? Colors.greenAccent : Colors.white),
          container(() {
            alarmController.onSelectDay(
                "isWed", alarmController.isWed == 1 ? 0 : 1);
          }, 'Wed',
              alarmController.isWed == 1 ? Colors.greenAccent : Colors.white),
          container(() {
            alarmController.onSelectDay(
                "isThu", alarmController.isThu == 1 ? 0 : 1);
          }, 'Thu',
              alarmController.isThu == 1 ? Colors.greenAccent : Colors.white),
          container(() {
            alarmController.onSelectDay(
                "isFri", alarmController.isFri == 1 ? 0 : 1);
          }, 'Fri',
              alarmController.isFri == 1 ? Colors.greenAccent : Colors.white),
          container(() {
            alarmController.onSelectDay(
                "isSat", alarmController.isSat == 1 ? 0 : 1);
          }, 'Sat',
              alarmController.isSat == 1 ? Colors.greenAccent : Colors.white),
          container(() {
            alarmController.onSelectDay(
                "isSun", alarmController.isSun == 1 ? 0 : 1);
          }, 'Sun',
              alarmController.isSun == 1 ? Colors.greenAccent : Colors.white),
        ],
      );
    });
  }

  Widget container(VoidCallback onPress, String label, Color color) {
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
          decoration: BoxDecoration(
            color: color,
            boxShadow: [
              const BoxShadow(
                blurRadius: 15,
                spreadRadius: 1,
                offset: Offset(4, 4),
                color: Colors.black,
              ),
              BoxShadow(
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(-4, -4),
                color: Colors.grey.shade800,
              ),
            ],
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Orbitron',
                fontSize: 10.sp),
          ),
        ),
      ),
    );
  }

  Widget labelText(AlarmController alarmController) {
    return TextFormField(
      validator: (value) {
        if (value == '') {
          return 'Please Enter label';
        }
        return null;
      },
      controller: alarmController.alarmLabel,
      decoration: InputDecoration(
        hintText: "Label",
        hintStyle: const TextStyle(
          fontFamily: 'Orbitron',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        focusColor: const Color(0xff65D1BA),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(
            color: Color(0xff65D1BA),
          ),
        ),
        prefixIcon: const Icon(
          Icons.label,
          color: Color(0xff65D1BA),
        ),
      ),
      cursorColor: const Color(0xff65D1BA),
    );
  }

  Widget optionBtns(AlarmController alarmController) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Vibrate"),
            Switch(
              value: alarmController.isVibrate,
              onChanged: (value) {
                alarmController.isActiveOnChange(value);
              },
            )
          ],
        ));
  }

  Widget timePicker(AlarmController alarmController, BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          alarmController.pickTime(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            boxShadow: [
              const BoxShadow(
                blurRadius: 15,
                spreadRadius: 1,
                offset: Offset(4, 4),
                color: Colors.black,
              ),
              BoxShadow(
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(-4, -4),
                color: Colors.grey.shade800,
              ),
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    format(alarmController, GetStorage().read('hourFormat')),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 60.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Orbitron'),
                  ),
                  Text(
                    ":",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 60.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Orbitron'),
                  ),
                  Text(
                    format(alarmController, "mm"),
                    style: TextStyle(
                      color: const Color(0xff65D1BA),
                      fontFamily: 'Orbitron',
                      fontSize: 60.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "",
                          style: TextStyle(
                              // color: Color(0xff65D1BA),
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Orbitron'),
                        ),
                        Visibility(
                          visible: GetStorage().read('hourFormat') == 'hh',
                          child: Text(
                            format(alarmController, 'a'),
                            style: TextStyle(
                                color: const Color(0xff65D1BA),
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Orbitron'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Text(
                "Tap to select time",
                style: TextStyle(
                  fontFamily: 'Orbitron',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String format(AlarmController alarmController, String format) {
    return DateFormat(format).format(DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      alarmController.selectedTime.hour,
      alarmController.selectedTime.minute,
    ));
  }
}
