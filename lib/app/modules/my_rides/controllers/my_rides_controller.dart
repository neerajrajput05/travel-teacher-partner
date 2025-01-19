// ignore_for_file: unnecessary_overrides

import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:get/get.dart';

class MyRidesController extends GetxController {
  RxList<BookingModel> ongoingRideList = <BookingModel>[].obs;
  RxList<BookingModel> completedRideList = <BookingModel>[].obs;
  RxList<BookingModel> canceledRideList = <BookingModel>[].obs;

  var selectedType = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getOngoingRides() async {
    List<BookingModel> response  = await getOngoingRidesList();
    ongoingRideList.assignAll(response);
  }

  getCompletedrides() async {
    List<BookingModel> response  = await getCompletedRidesList();
    completedRideList.assignAll(response);
  }

  getCanceledRide() async {
    List<BookingModel> response = await getCanceledRidesList();
    canceledRideList.assignAll(response);
  }
}
