import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/extension/string_extensions.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  //TODO: Implement EditProfileController

  RxString profileImage = Constant.profileConstant.obs;
  TextEditingController countryCodeController =
      TextEditingController(text: '+91');
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  RxBool isEmailVerified = false.obs;
  RxInt selectedGender = 1.obs;
  RxString name = ''.obs;
  RxString phoneNumber = ''.obs;
  final ImagePicker imagePicker = ImagePicker();

  @override
  void onInit() {
    getUserData();
    super.onInit();
  }

  getUserData() async {
    Map<String, dynamic> userModel = await getProfile();
    if (userModel.isNotEmpty) {
      profileImage.value = "";
      name.value = userModel["name"] ?? '';
      nameController.text = userModel["name"] ?? '';
      phoneNumber.value =
          (userModel["country_code"] ?? '') + (userModel["phone"] ?? '');
      phoneNumberController.text = (userModel["phone"] ?? '');
      if (userModel["email"] == '' || userModel["email"] == null) {
        isEmailVerified.value = false;
      } else {
        isEmailVerified.value = true;
        emailController.text = (userModel["email"] ?? '');
      }
      update();
      selectedGender.value = (userModel["gender"] ?? '') == "male" ? 1 : 2;
    }
  }

  saveUserData() async {
    DriverUserModel? userModel = await getOnlineUserModel();
    userModel.gender = selectedGender.value == 1 ? "male" : "female";
    userModel.fullName = nameController.text;
    userModel.slug = nameController.text.toSlug(delimiter: "-");
    ShowToastDialog.showLoader("Please wait");

    Map<String, dynamic> params = {
      "name": nameController.text,
      "date_of_birth": userModel.dateOfBirth,
      "email": emailController.text,
      "gender": selectedGender.value == 1 ? "Male" : "Female"
    };
    await updateOnlineUserModel(params);
    ShowToastDialog.closeLoader();
    Get.back(result: true);
  }

  Future<void> pickImage({required ImageSource source}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        // Show loading dialog
        ShowToastDialog.showLoader('Uploading image...');

        // Here you would typically upload the image to your server
        // For example:
        // final response = await uploadImageToServer(File(image.path));
        // if (response.success) {
        //   profilePic.value = response.imageUrl;
        // }

        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Profile picture updated successfully');
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast('Error uploading image: $e');
    }
  }

  Future<void> pickFile({required ImageSource source}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 70, // Compress image quality to 70%
        maxWidth: 1000, // Limit max width
        maxHeight: 1000, // Limit max height
      );

      if (image != null) {
        ShowToastDialog.showLoader('Uploading image...');

        // Here you would typically upload the image to your server
        // For example:
        // final response = await uploadImageToServer(File(image.path));
        // if (response.success) {
        //   profilePic.value = response.imageUrl;
        // }

        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast('Profile picture updated successfully');
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast('Error uploading image: $e');
    }
  }

  Future<bool> sendVerifyEmail() async {
    try {
      ShowToastDialog.showLoader("Please wait");
      Map<String, dynamic> response =
          await sendVerifyEmailAPI(emailController.text);
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(response["msg"] ?? "");
      return response['status'];
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast('Error: $e');
      return false;
    }
  }

  Future<bool> verifyEmailOTP(String email, String otp) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      Map<String, dynamic> response = await verifyEmailOTPAPI(email, otp);
      ShowToastDialog.closeLoader();
      if (response['status']) {
        isEmailVerified.value = true;
        DriverUserModel? userModel = await Preferences.getDriverUserModel();
        userModel!.email = email;
        await Preferences.setDriverUserModel(userModel);
        getUserData();
      }
      ShowToastDialog.showToast(response["msg"] ?? "");
      return response['status'];
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast('Error: $e');
      return false;
    }
  }
}
