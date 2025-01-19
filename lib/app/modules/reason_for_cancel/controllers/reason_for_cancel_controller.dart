// ignore_for_file: unnecessary_overrides
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/ride_reason_list.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/booking_model.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/utils/fire_store_utils.dart';

class ReasonForCancelController extends GetxController {
  Rx<BookingModel> bookingModel = BookingModel().obs;
  Rx<TextEditingController> otherReasonController = TextEditingController().obs;
  RxList<RideCancelResaons> reasons = <RideCancelResaons>[].obs;

  @override
  void onInit() {
    super.onInit();
    getReasonList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  RxInt selectedIndex = 0.obs;

  Future<bool> cancelBooking(BookingModel bookingModels) async {
    BookingModel bookingModel = bookingModels;
    bookingModel.status = BookingStatus.bookingRejected;
    bookingModel.cancelledBy = FireStoreUtils.getCurrentUid();
    bookingModel.driverId = FireStoreUtils.getCurrentUid();
    bookingModel.cancelledBy = reasons[selectedIndex.value] != "Other"
        ? reasons[selectedIndex.value].toString()
        : "${reasons[selectedIndex.value].toString()} : ${otherReasonController.value.text}";
    List rejectedId = bookingModel.rejectedDriverId ?? [];
    rejectedId.add(FireStoreUtils.getCurrentUid());
    // bookingModel.rejectedDriverId = rejectedId;
    bookingModel.updatedAt = Timestamp.now().toString();
    bool? isCancelled = await FireStoreUtils.setBooking(bookingModel);
    return (isCancelled ?? false);
  }
  
  void getReasonList() async {
    reasons.value = await getCancelReasonsList();
  }

  // sendCancelRideNotification() async {
  //   UserModel? receiverUserModel = await FireStoreUtils.getUserProfile(bookingModel.value.customerId.toString());
  //   Map<String, dynamic> playLoad = <String, dynamic>{"bookingId": bookingModel.value.id};
  //   await SendNotification.sendOneNotification(
  //       type: "order",
  //       token: receiverUserModel!.fcmToken.toString(),
  //       title: 'Ride Cancelled'.tr,
  //       body: 'Ride #${bookingModel.value.id.toString().substring(0, 4)} is Rejected by Driver',
  //       bookingId: bookingModel.value.id,
  //       driverId: bookingModel.value.driverId.toString(),
  //       customerId: receiverUserModel.id,
  //       senderId: FireStoreUtils.getCurrentUid(),
  //       payload: playLoad);
  // }
}
