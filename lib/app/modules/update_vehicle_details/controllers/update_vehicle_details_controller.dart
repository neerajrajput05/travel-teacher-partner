import 'dart:io';

import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/vehicle_brand_model.dart';
import 'package:driver/app/models/vehicle_type_model.dart';
import 'package:driver/app/modules/verify_documents/controllers/verify_documents_controller.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateVehicleDetailsController extends GetxController {
  Rx<VehicleTypeModel> vehicleTypeModel = VehicleTypeModel(
    id: "",
    image: "",
    activeStatus: "inactive",
    name: "",
    slug: "0",
  ).obs;
  Rx<VehicleBrandModel> vehicleBrandModel = VehicleBrandModel.empty().obs;
  Rx<VehicleModel> vehicleModel = VehicleModel.empty().obs;
  Rx<String> imagePath = "".obs;
  RxList<VehicleTypeModel> vehicleTypeList = <VehicleTypeModel>[].obs;
  RxList<VehicleBrandModel> vehicleBrandList = <VehicleBrandModel>[].obs;
  RxList<VehicleModel> vehicleModelList = <VehicleModel>[].obs;
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleBrandController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();

  @override
  Future<void> onReady() async {
    final result = await getVehicleTypeDetail();
    List<dynamic> listType = (result)["data"] as List;
    vehicleTypeList.value =
        listType.map((item) => VehicleTypeModel.fromJson(item)).toList();
    vehicleTypeModel.value = vehicleTypeList[0];
    final response = await getVehicleDetial();
    List<dynamic> list = (response)["data"] as List;
    vehicleBrandList.value =
        list.map((item) => VehicleBrandModel.fromJson(item)).toList();
    updateData();
    super.onReady();
  }

  updateData() {
    VerifyDocumentsController uploadDocumentsController =
        Get.find<VerifyDocumentsController>();
    if (uploadDocumentsController.userModel.value.driverVehicleDetails !=
        null) {
      int typeIndex = vehicleTypeList.indexWhere((element) =>
          element.id ==
          uploadDocumentsController
              .userModel.value.driverVehicleDetails!.vehicleTypeId);
      print("Type Index : $typeIndex");
      if (typeIndex != -1) vehicleTypeModel.value = vehicleTypeList[typeIndex];
      vehicleBrandController.text = uploadDocumentsController
              .userModel.value.driverVehicleDetails!.brandName ??
          '';
      vehicleModelController.text = uploadDocumentsController
              .userModel.value.driverVehicleDetails!.modelName ??
          '';
      vehicleNumberController.text = uploadDocumentsController
              .userModel.value.driverVehicleDetails!.vehicleNumber ??
          '';
    }
  }

  getVehicleModel(String id) async {
    // Match the ID from vehicleBrandList and filter the models
    vehicleModelList.value = vehicleBrandList
        .where((brand) => brand.id == id)
        .map((brand) => brand
            .models) // Assuming 'models' is a property of VehicleBrandModel
        .expand((modelList) => modelList) // Flatten the list of lists
        .toList();
  }

  saveVehicleDetails() async {
    try {
      ShowToastDialog.showLoader("please_wait".tr);
      DriverUserModel? userModel = await Preferences.getDriverUserModel();
      if (userModel == null) {
        ShowToastDialog.closeLoader();
        return;
      }
      VerifyDocumentsController verifyDocumentsController =
          Get.find<VerifyDocumentsController>();
      DriverVehicleDetails driverVehicleDetails = DriverVehicleDetails(
        // brandName: vehicleBrandModel.value.title,
        // brandId: vehicleBrandModel.value.id,
        modelName: vehicleModel.value.name,
        modelId: vehicleModel.value.id,
        vehicleNumber: vehicleNumberController.text,
        isVerified: false,
        vehicleTypeName: vehicleTypeModel.value.name,
        vehicleTypeId: vehicleTypeModel.value.id,
      );
      userModel.driverVehicleDetails = driverVehicleDetails;
      print("==> ${userModel.driverVehicleDetails!.toJson()}");

      bool isUpdated = await FireStoreUtils.updateDriverUser(userModel);
      ShowToastDialog.closeLoader();
      if (isUpdated) {
        ShowToastDialog.showToast(
            "Vehicle details updated, Please wait for verification.");
        verifyDocumentsController.getData();
        Get.back();
      } else {
        ShowToastDialog.showLoader("please_wait".tr);
        ShowToastDialog.showToast(
            "Something went wrong, Please try again later.");
        Get.back();
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> pickFile({
    required ImageSource source,
    required int index,
  }) async {
    try {
      XFile? image =
          await imagePicker.pickImage(source: source, imageQuality: 60);
      if (image == null) return;
      Get.back();
      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 50,
      );
      File compressedFile = File(image.path);
      await compressedFile.writeAsBytes(compressedBytes!);
      imagePath.value = compressedFile.path;
    } on PlatformException {
      ShowToastDialog.showToast("Failed to pick");
    }
  }
}
