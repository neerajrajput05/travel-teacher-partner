import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/modules/home/views/home_view.dart';
import 'package:driver/app/modules/verify_documents/views/verify_documents_view.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/extension/string_extensions.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  TextEditingController countryCodeController =
      TextEditingController(text: '+91');
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
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
      if (loginType.value == Constant.phoneLoginType) {
        phoneNumberController.text = userModel.value.phoneNumber.toString();
        countryCodeController.text = userModel.value.countryCode.toString();
      } else {
        emailController.text = userModel.value.email.toString();
        nameController.text = userModel.value.fullName.toString();
      }
    }
    update();
  }

  createAccount(String token) async {
    String fcmToken = token;
    ShowToastDialog.showLoader("please_wait".tr);
    DriverUserModel userModelData = userModel.value;
    userModelData.fullName = nameController.value.text;
    userModelData.slug = nameController.value.text.toSlug(delimiter: "-");
    userModelData.email = emailController.value.text;
    userModelData.countryCode = countryCodeController.value.text;
    userModelData.phoneNumber = phoneNumberController.value.text;
    userModelData.gender = selectedGender.value == 1 ? "Male" : "Female";
    userModelData.profilePic = '';
    userModelData.fcmToken = fcmToken;
    userModelData.createdAt = Timestamp.now();
    userModelData.isActive = true;
    userModelData.isVerified = false;

    try {
      ShowToastDialog.showLoader("please_wait".tr);

      final responseData = await createNewAccount(
          userModelData.fullName!, userModelData.gender!, fcmToken);

      userModelData.id = responseData["data"]["_id"];

      Preferences.setDriverUserModel(userModelData);

      if (userModelData.isActive == true) {
        if (userModelData.isVerified == false) {
          // bool permissionGiven = await Constant.isPermissionApplied();
          // if (permissionGiven) {
          Get.offAll(const VerifyDocumentsView(
            isFromDrawer: false,
          ));
          // ));
          // } else {
          //   Get.offAll(const PermissionView());
          // }
        } else {
          ShowToastDialog.closeLoader();
          Get.offAll(const HomeView());
        }
      } else {
        // await FirebaseAuth.instance.signOut();
        ShowToastDialog.showToast("user_disable_admin_contact".tr);
      }

      ShowToastDialog.closeLoader();

      ShowToastDialog.showToast(responseData['msg'].toString().split(",")[0]);
    } catch (e) {
      // log(e.toString());
      bool permissionGiven = await Constant.isPermissionApplied();
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("something went wrong!".tr);
    }
  }
}
