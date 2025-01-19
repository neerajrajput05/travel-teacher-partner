// ignore_for_file: unnecessary_overrides

import 'dart:async';

import 'package:driver/app/modules/home_owner_screen/views/home_owner_view.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/modules/home/views/home_view.dart';
import 'package:driver/app/modules/intro_screen/views/intro_screen_view.dart';
import 'package:driver/app/modules/login/views/login_view.dart';
import 'package:driver/app/modules/permission/views/permission_view.dart';
import 'package:driver/app/modules/verify_documents/views/verify_documents_view.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/utils/preferences.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    Timer(const Duration(seconds: 3), () => redirectScreen());
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  redirectScreen() async {
    if ((await Preferences.getBoolean(Preferences.isFinishOnBoardingKey)) ==
        false) {
      Get.offAll(const IntroScreenView());
    } else {
      bool isLogin = await Preferences.getUserLoginStatus();
      bool isOwnerLogin = await Preferences.isOwnerLogin();

      if (isOwnerLogin) {
        if (await Preferences.getDocVerifyStatus()) {
          Get.offAll(const HomeOwnerView());
        } else {
          Get.offAll(const VerifyDocumentsView(isFromDrawer: false,));
        }
      } else if (isLogin == true) {
        DriverUserModel? userModel = await getOnlineUserModel();

        await Preferences.setDriverUserModel(userModel);

        if (userModel.isVerified == true) {
          try {
            if (!await Preferences.getDocVerifyStatus()) {
              Get.offAll(const VerifyDocumentsView(
                isFromDrawer: false,
              ));
            } else if (await Constant.isPermissionApplied()) {
              Get.offAll(const HomeView());
            } else {
              Get.offAll(const PermissionView());
            }
          } catch (e) {
            Get.offAll(const HomeView());
          }
        } else {
          if (userModel.fullName == null) {
            Get.offAll(const LoginView());
          } else {
            Get.offAll(const VerifyDocumentsView(isFromDrawer: false));
          }
        }
      } else {
        Get.offAll(const LoginView());
      }
    }
  }
}
