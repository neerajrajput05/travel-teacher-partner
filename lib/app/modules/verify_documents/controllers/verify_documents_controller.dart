// ignore_for_file: unnecessary_overrides

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:driver/app/models/docsModel.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/documents_model.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/verify_driver_model.dart';
import 'package:image_picker/image_picker.dart';

class VerifyDocumentsController extends GetxController {
  RxList<DocumentsModel> documentList = <DocumentsModel>[].obs;
  Rx<VerifyDriverModel> verifyDriverModel = VerifyDriverModel().obs;
  Rx<DriverUserModel> userModel = DriverUserModel().obs;
  RxBool isVerified = false.obs;
  RxBool isOwner = false.obs;
  final ImagePicker imagePicker = ImagePicker();

  @override
  void onInit() {
    getData();
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

  getData() async {
    documentList.clear();
    isOwner.value = await Preferences.isOwnerLogin();
    // verifyDriverModel.value = await FireStoreUtils.getVerifyDriver(FireStoreUtils.getCurrentUid()) ?? VerifyDriverModel();
    final response = await getListOfUploadDocument();
    List<DocumentsModel> documentListL = List.from([]);
    for (var element in response["data"]) {
      DocumentsModel vehicleTypeModel = DocumentsModel.fromJson(element);
      documentListL.add(vehicleTypeModel);
    }
    documentList.value = documentListL;
    userModel.value =
        await Preferences.getDriverUserModel() ?? DriverUserModel();
    // userModel.value = await FireStoreUtils.getDriverUserProfile(
    //         FireStoreUtils.getCurrentUid()) ??
    //     DriverUserModel();
  }

  bool checkUploadedData(String documentId) {
    // List<VerifyDocument> doc = verifyDriverModel.value.verifyDocument ?? [];
    // int index = doc.indexWhere((element) => element.documentId == documentId);

    // return index != -1;
    DriverUserModel? userModel = Preferences.userModel;

    List<DocsModel> list = List.from(userModel?.driverdDocs ?? []);

    for (int i = 0; i <= list.length - 1; i++) {
      DocsModel model = list[i];
      if (model.id == documentId) return true;
    }

    return false;
  }

  bool checkVerifiedData(String documentId) {
    // List<VerifyDocument> doc = verifyDriverModel.value.verifyDocument ?? [];
    // int index = doc.indexWhere((element) => element.documentId == documentId);
    // if (index != -1) {
    //   return doc[index].isVerify ?? false;
    // } else {
    //   return false;
    // }

    DriverUserModel? userModel = Preferences.userModel;

    List<DocsModel> list = List.from(userModel?.driverdDocs ?? []);

    for (int i = 0; i <= list.length - 1; i++) {
      DocsModel model = list[i];
      if (model.id == documentId) {
        return true;
      }
    }

    return false;
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
      ShowToastDialog.showLoader("please_wait".tr);
      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 50,
      );
      File compressedFile = File(image.path);
      await compressedFile.writeAsBytes(compressedBytes!);
      File imagePath = File(compressedFile.path);
      List<int> imageBytes = await image.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      base64Image = "data:image/png;base64,$base64Image";
      Map<String, dynamic> response = await uploadProfilePicture(base64Image);
      ShowToastDialog.showToast(response["msg"]);
      if (response["status"] == true) {
        ShowToastDialog.closeLoader();
        userModel.value.profilePic = response["data"];
        await Preferences.setDriverUserModel(userModel.value);
      } else {
        ShowToastDialog.showToast(response["msg"]);
        ShowToastDialog.closeLoader();
      }
    } on PlatformException {
      ShowToastDialog.showToast("Failed to pick");
      ShowToastDialog.closeLoader();
    }
  }
}
