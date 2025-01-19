import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/modules/home_owner_screen/views/home_owner_view.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CreateOwnDriverController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  TextEditingController countryCodeController =
      TextEditingController(text: '+91');
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
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
        nameController.text = userModel.value.fullName.toString();
      }
    }
    update();
  }

  createyourDriverAccount() async {
    ShowToastDialog.showLoader("please_wait".tr);

    Map<String, dynamic> driverMap = {
      "name": nameController.value.text,
      "phone": phoneNumberController.value.text,
      "date_of_birth": dobController.text,
      "gender": selectedGender.value == 1 ? "Male" : "Female",
      "email": emailController.value.text,
      "password": passwordController.value.text,
      "confirm_password": confirmPassController.value.text,
    };

    try {
      ShowToastDialog.showLoader("please_wait".tr);

      final responseData = await createYourDriverAccount(driverMap);

      if (responseData["status"] == true) {
        Get.to(() => const HomeOwnerView());
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
