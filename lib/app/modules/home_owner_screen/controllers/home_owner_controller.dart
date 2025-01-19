import 'dart:async';

import 'package:driver/app/models/my_driver_model.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/review_customer_model.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeOwnerController extends GetxController {
  RxString profilePic = Constant.profileConstant.obs;
  RxString name = ''.obs;
  RxString phoneNumber = ''.obs;
  RxBool isOnline = false.obs;
  RxBool isLoading = false.obs;
  Rx<DriverUserModel> userModel = DriverUserModel().obs;
  RxList<ReviewModel> reviewList = <ReviewModel>[].obs;
  RxInt drawerIndex = 0.obs;
  List<Color> colorList = [
    AppThemData.bookingNew,
    AppThemData.bookingOngoing,
    AppThemData.bookingCompleted,
    AppThemData.bookingRejected,
    AppThemData.bookingCancelled
  ];
  RxMap<String, double> dataMap = <String, double>{
    "New": 0,
    "Ongoing": 0,
    "Completed": 0,
    "Rejected": 0,
    "Cancelled": 0,
  }.obs;
  RxList color = [
    AppThemData.secondary50,
    AppThemData.success50,
    AppThemData.danger50,
    AppThemData.info50
  ].obs;
  RxList colorDark = [
    AppThemData.secondary950,
    AppThemData.success950,
    AppThemData.danger950,
    AppThemData.info950
  ].obs;

  RxInt totalRides = 0.obs;
  late IO.Socket socket;

  late Timer _timer;

  RxList<MyDriverModel> driverList = <MyDriverModel>[].obs;

  RxInt startIndex = 0.obs;
  RxInt endIndex = 10.obs; // Default value

  @override
  void onInit() {
    getListOfDriver();
    super.onInit();
  }


  @override
  void onClose() {
    socket.disconnect();
    super.onClose();
  }

  getListOfDriver() async {
    isLoading.value = true;
    final List<MyDriverModel> list = await getDriverList(0,20);
    driverList.assignAll(list);
    isLoading.value = false;
  }
}
