import 'package:driver/app/modules/home_owner_screen/views/home_owner_view.dart';
import 'package:driver/app/modules/verify_documents/views/verify_documents_view.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/constant_widgets/text_field_with_title.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/verify_otp_controller.dart';

class DriverVerifyOtpView extends StatelessWidget {
  String email;

  DriverVerifyOtpView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    String otp = "";
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<DriverVerifyOtpontroller>(
        init: DriverVerifyOtpontroller(),
        builder: (controller) {
          return GestureDetector(
            onTap: () {
              bool isFocus = FocusScope.of(context).hasFocus;
              if (isFocus) {
                FocusScope.of(context).unfocus();
              }
            },
            child: Scaffold(
              backgroundColor: themeChange.isDarkTheme()
                  ? AppThemData.black
                  : AppThemData.white,
              appBar: AppBar(
                forceMaterialTransparency: true,
                backgroundColor: themeChange.isDarkTheme()
                    ? AppThemData.black
                    : AppThemData.white,
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_rounded)),
                iconTheme: IconThemeData(
                    color: themeChange.isDarkTheme()
                        ? AppThemData.white
                        : AppThemData.black),
              ),
              body: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 31),
                child: Column(
                  children: [
                    Text(
                      "Verify Your Email".tr,
                      style: GoogleFonts.inter(
                          fontSize: 24,
                          color: themeChange.isDarkTheme()
                              ? AppThemData.white
                              : AppThemData.black,
                          fontWeight: FontWeight.w700),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 33),
                      child: Text(
                        "Enter  6-digit code sent to your email to complete verification."
                            .tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: themeChange.isDarkTheme()
                                ? AppThemData.white
                                : AppThemData.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    TextFieldWithTitle(
                      title: "Enter OTP",
                      hintText: "",
                      maxLength: 6,
                      prefixIcon: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      controller: controller.otpController,
                      isEnable: true,
                    ),
                    const SizedBox(height: 90),
                    RoundShapeButton(
                        size: const Size(200, 45),
                        title: "verify_OTP".tr,
                        buttonColor: AppThemData.primary500,
                        buttonTextColor: AppThemData.black,
                        onTap: () async {
                          if (controller.otpController.text.length == 6) {
                            ShowToastDialog.showLoader("verify_OTP".tr);

                            try {
                              ShowToastDialog.showLoader("please_wait".tr);

                              final responseData = await verifyDriverOtp(
                                controller.otpController.text.toString(),
                                email,
                              );

                              if (responseData["status"] == true) {
                                ShowToastDialog.showToast(
                                    '${responseData["msg"]}');
                                Preferences.setFcmToken(responseData["token"]);
                                Preferences.setOwnerLoginStatus(true);
                                if (responseData["document_status"] == false) {
                                  Get.offAll(() => const VerifyDocumentsView(
                                        isFromDrawer: false,
                                        forOwner: true,
                                      ));
                                } else {
                                  Preferences.setDocVerifyStatus(true);
                                  Get.offAll(() => const HomeOwnerView());
                                }
                              } else {
                                ShowToastDialog.showToast(
                                    'Failed to verify OTP: ${responseData["msg"]}');
                              }

                              ShowToastDialog.closeLoader();
                            } catch (e) {
                              // log(e.toString());
                              ShowToastDialog.closeLoader();
                              ShowToastDialog.showToast(
                                  "something went wrong!".tr);
                            }
                          } else {
                            ShowToastDialog.showToast('Enter valid OTP');
                          }
                        }),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
