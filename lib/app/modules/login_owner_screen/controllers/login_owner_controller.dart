
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/modules/home/views/home_view.dart';
import 'package:driver/app/modules/home_owner_screen/views/home_owner_view.dart';
import 'package:driver/app/modules/verify_documents/views/verify_documents_view.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginOnwerController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxInt selectedGender = 1.obs;
  RxString loginType = "".obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Rx<DriverUserModel> userModel = DriverUserModel().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      userModel.value = argumentData['userModel'];
      loginType.value = userModel.value.loginType.toString();
      // if (loginType.value == Constant.phoneLoginType) {
      // } else {
      //   nameController.text = userModel.value.fullName.toString();
      // }
    }
    update();
  }

  loginOwnerAccount() async {
    ShowToastDialog.showLoader("please_wait".tr);

    Map<String, dynamic> driverMap = {
      "input": emailController.text,
      "password": passwordController.text,
    };

    try {
      ShowToastDialog.showLoader("please_wait".tr);

      final responseData = await loginOnwerAccount(driverMap);

      if (responseData["status"] == true) {
        Preferences.setFcmToken(responseData["token"]);
        Preferences.setOwnerLoginStatus(true);
        if (responseData["document_status"] == false) {
          Get.offAll(() => const VerifyDocumentsView(
                isFromDrawer: false,
              ));
        } else {
          Preferences.setDocVerifyStatus(true);
          Get.offAll(() => const HomeOwnerView());
        }
      }

      ShowToastDialog.closeLoader();

      ShowToastDialog.showToast(responseData['msg'].toString().split(",")[0]);
    } catch (e) {
      // log(e.toString());
      bool permissionGiven = await Constant.isPermissionApplied();
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
  }

  loginDriverAccount() async {
    ShowToastDialog.showLoader("please_wait".tr);

    Map<String, dynamic> driverMap = {
      "input": emailController.text,
      "password": passwordController.text,
    };

    try {
      ShowToastDialog.showLoader("please_wait".tr);

      final responseData = await loginDriverAccountWithEmailPass(driverMap);

      if (responseData["status"] == true) {
        Preferences.setFcmToken(responseData["token"]);
        Preferences.setUserLoginStatus(true);
        if (responseData["document_status"] == false) {
          Get.offAll(() => const VerifyDocumentsView(
                isFromDrawer: false,
              ));
        } else {
          Preferences.setDocVerifyStatus(true);
          Get.offAll(() => const HomeView());
        }
      }

      ShowToastDialog.closeLoader();

      ShowToastDialog.showToast(responseData['msg'].toString().split(",")[0]);
    } catch (e) {
      // log(e.toString());
      bool permissionGiven = await Constant.isPermissionApplied();
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
  }
}
