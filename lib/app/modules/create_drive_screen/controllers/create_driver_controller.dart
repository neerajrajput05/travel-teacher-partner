import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/modules/verify_driver_otp/views/verify_otp_view.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CreateDriverController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  TextEditingController countryCodeController =
      TextEditingController(text: '+91');
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confrimpasswordController = TextEditingController();
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

  createDriverAccount() async {
    ShowToastDialog.showLoader("please_wait".tr);

    Map<String, dynamic> driverMap = {
      "name": nameController.value.text,
      "phone": phoneNumberController.value.text,
      "email": emailController.text,
      "password": passwordController.text,
      "confirm_password": confrimpasswordController.text,
    };

    try {
      ShowToastDialog.showLoader("please_wait".tr);

      final responseData = await createNewDriverAccount(driverMap);

      if (responseData["status"] == true) {
        List<String> otp = responseData["msg"].toString().split(" ");
        Get.to(() => DriverVerifyOtpView(
              email: emailController.text,
            ));
      }

      ShowToastDialog.closeLoader();

      ShowToastDialog.showToast(responseData['msg'].toString().split(",")[0]);
    } catch (e) {
      // log(e.toString());
      // bool permissionGiven = await Constant.isPermissionApplied();
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
  }
}
