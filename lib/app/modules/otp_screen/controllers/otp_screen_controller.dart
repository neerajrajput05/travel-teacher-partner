// ignore_for_file: unnecessary_overrides

import 'package:driver/app/services/api_service.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/models/user_model.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/utils/fire_store_utils.dart';

class OtpScreenController extends GetxController {
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

  RxString otp = ''.obs;

  Future<bool> startBooking(RideData bookingModels) async {
    // RideData bookingModel = BookingModel.fromJson(bookingModels.toJson());
    // bookingModel.status = BookingStatus.bookingOngoing;
    // bookingModel.updatedAt = Timestamp.now().toString();
    // bookingModel.createdAt = Timestamp.now().toString();
    bool? isStarted = await verifyOtpRequest(bookingModels);

    ShowToastDialog.showToast("Your ride started....");
    UserModel? receiverUserModel =
        await FireStoreUtils.getUserProfile(bookingModels.driverId.toString());
    Map<String, dynamic> playLoad = <String, dynamic>{
      "bookingId": bookingModels.id
    };

    if (isStarted) {
      await SendNotification.sendOneNotification(
          type: "order",
          token: receiverUserModel!.fcmToken.toString(),
          title: 'Your Ride is Started',
          customerId: receiverUserModel.id,
          senderId: FireStoreUtils.getCurrentUid(),
          bookingId: bookingModels.id.toString(),
          driverId: bookingModels.driverId.toString(),
          body:
              'Your Ride is Started From ${bookingModels.pickupAddress.toString()} to ${bookingModels.dropoffAddress.toString()}.',
          payload: playLoad);
    }

    // Get.offAll(const HomeView());
    return (isStarted ?? false);
  }
}
