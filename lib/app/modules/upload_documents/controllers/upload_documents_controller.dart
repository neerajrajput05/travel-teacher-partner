// ignore_for_file: unnecessary_overrides

import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:driver/app/models/docsModel.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/documents_model.dart';
import 'package:driver/app/models/verify_driver_model.dart';
import 'package:driver/app/modules/verify_documents/controllers/verify_documents_controller.dart';
import 'package:driver/constant_widgets/network_image_widget.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/theme/responsive.dart';
import 'package:image_picker/image_picker.dart';

class UploadDocumentsController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  PageController controller = PageController();
  RxInt pageIndex = 0.obs;

  final ImagePicker imagePicker = ImagePicker();

  Rx<VerifyDocument> verifyDocument =
      VerifyDocument(documentImage: ['', '']).obs;
  RxList<Widget> imageWidgetList = <Widget>[].obs;
  RxList<int> imageList = <int>[].obs;

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

  setData(bool isUploaded, String id, BuildContext context) {
    imageWidgetList.clear();
    VerifyDocumentsController uploadDocumentsController =
        Get.find<VerifyDocumentsController>();
    if (isUploaded) {
      int index = uploadDocumentsController
          .verifyDriverModel.value.verifyDocument!
          .indexWhere((element) => element.documentId == id);
      if (index != -1) {
        for (var element in uploadDocumentsController
            .verifyDriverModel.value.verifyDocument![index].documentImage) {
          imageList.add(uploadDocumentsController
              .verifyDriverModel.value.verifyDocument![index].documentImage
              .indexOf(element));
          imageWidgetList.add(
            Center(
              child: NetworkImageWidget(
                imageUrl: element.toString(),
                height: 220,
                width: Responsive.width(100, context),
                borderRadius: 12,
                fit: BoxFit.cover,
              ),
            ),
          );
        }

        nameController.text = uploadDocumentsController
                .verifyDriverModel.value.verifyDocument![index].name ??
            '';
        numberController.text = uploadDocumentsController
                .verifyDriverModel.value.verifyDocument![index].number ??
            '';
        dobController.text = uploadDocumentsController
                .verifyDriverModel.value.verifyDocument![index].dob ??
            '';
      }
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
      List<dynamic> files = verifyDocument.value.documentImage;
      files.removeAt(index);
      files.insert(index, compressedFile.path);
      verifyDocument.value = VerifyDocument(documentImage: files);
    } on PlatformException {
      ShowToastDialog.showToast("Failed to pick");
    }
  }

  uploadDocument(
      DocumentsModel document, List<dynamic> Listr, controller) async {
    ShowToastDialog.showLoader("Please wait");

    List<String> imageList = List.from([]);

    if (verifyDocument.value.documentImage.isNotEmpty) {
      for (int i = 0; i < verifyDocument.value.documentImage.length; i++) {
        if (verifyDocument.value.documentImage[i].isNotEmpty) {
          File image = File(verifyDocument.value.documentImage[i].toString());
          List<int> imageBytes = await image.readAsBytes();
          String base64Image = base64Encode(imageBytes);
          imageList.add("data:image/png;base64,$base64Image");
        }
      }
    }

    DocsModel docsModel = DocsModel(
        type: document.slug,
        document_number: controller.numberController.text,
        name: controller.nameController.text,
        date_of_birth: controller.dobController.text,
        image: imageList,
        id: document.id);

    bool isUpdated = await uploadDriverDocumentImageToStorage(docsModel);
    ShowToastDialog.closeLoader();
    if (isUpdated) {
      ShowToastDialog.showToast(
          "${document.title} updated, Please wait for verification.");
      Get.back();
    } else {
      ShowToastDialog.showToast(
          "Something went wrong, Please try again later.");
      Get.back();
    }
  }
}
