import 'package:driver/app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';

class DriverVerifyOtpontroller extends GetxController {
TextEditingController otpController = TextEditingController();

  RxString otpCode = "".obs;
  RxString countryCode = "".obs;
  RxString phoneNumber = "".obs;
  RxString verificationId = "".obs;
  RxInt resendToken = 0.obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  @override
  void onClose() {}

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      countryCode.value = argumentData['countryCode'];
      phoneNumber.value = argumentData['phoneNumber'];
      verificationId.value = argumentData['verificationId'];
    }
    isLoading.value = false;
    update();
  }

  Future<bool> sendOTP() async {
    ShowToastDialog.showLoader("please_wait".tr);
    try {
      ShowToastDialog.showLoader("please_wait".tr);

      final responseData = await sendOtp(
        countryCode.value,
        phoneNumber.value,
      );

      ShowToastDialog.closeLoader();

      if (responseData["status"] == true) {
        ShowToastDialog.showToast(responseData['msg'].toString().split(",")[0]);
      } else {
        ShowToastDialog.showToast('Failed to send OTP: ${responseData["msg"]}');
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("something went wrong!".tr);
    }
    // await FirebaseAuth.instance.verifyPhoneNumber(
    //   phoneNumber: countryCode.value + phoneNumber.value,
    //   verificationCompleted: (PhoneAuthCredential credential) {},
    //   verificationFailed: (FirebaseAuthException e) {},
    //   codeSent: (String verificationId0, int? resendToken0) async {
    //     verificationId.value = verificationId0;
    //     resendToken.value = resendToken0!;
    //   },
    //   timeout: const Duration(seconds: 25),
    //   forceResendingToken: resendToken.value,
    //   codeAutoRetrievalTimeout: (String verificationId0) {
    //     verificationId0 = verificationId.value;
    //   },
    // );
    ShowToastDialog.closeLoader();
    return true;
  }
}
