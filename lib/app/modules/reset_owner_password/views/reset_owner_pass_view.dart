import 'package:driver/app/services/api_service.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/constant_widgets/text_field_with_title.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../controllers/reset_owner_pass_controller.dart';

class ResetOwnerPassView extends StatelessWidget {
  const ResetOwnerPassView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<ResetOwnerPassController>(
        init: ResetOwnerPassController(),
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
                      "Reset Account Password".tr,
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
                        "Verify your account".tr,
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
                      title: "Email Address",
                      hintText: "Enter registered email address",
                      prefixIcon: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      controller: controller.emailController,
                      isEnable: !controller.isOtpVisible.value,
                      validator: (value) => Constant().validateEmail(value),
                    ),
                    Visibility(
                      visible: controller.isOtpVisible.value,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text("Enter OTP")),
                          OTPTextField(
                            length: 6,
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 40,
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                color: themeChange.isDarkTheme()
                                    ? AppThemData.white
                                    : AppThemData.grey950,
                                fontWeight: FontWeight.w500),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            otpFieldStyle: OtpFieldStyle(
                              focusBorderColor: AppThemData.primary500,
                              borderColor: AppThemData.grey100,
                              enabledBorderColor: AppThemData.grey100,
                            ),
                            fieldStyle: FieldStyle.underline,
                          ),
                          const SizedBox(height: 30),
                          TextFieldWithTitle(
                            title: "Password",
                            hintText: "Enter your password",
                            prefixIcon: const Icon(Icons.password),
                            keyboardType: TextInputType.visiblePassword,
                            controller: controller.passwordController,
                            obscureText: true,
                            isEnable: true,
                            validator: (value) =>
                                Constant().validateRequired(value, "Password"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 90),
                    RoundShapeButton(
                        size: const Size(200, 45),
                        title: "verify_OTP".tr,
                        buttonColor: AppThemData.primary500,
                        buttonTextColor: AppThemData.black,
                        onTap: () async {
                          try {
                            ShowToastDialog.showLoader("please_wait".tr);

                            final responseData =
                                await verifyOwnerEmailResetPassword(
                              controller.emailController.text,
                            );

                            if (responseData["status"] == true) {
                              ShowToastDialog.showToast(
                                  '${responseData["msg"]}');
                              controller.isOtpVisible.value = true;
                              controller.emailController.text =
                                  controller.emailController.text;
                            } else {
                              ShowToastDialog.showToast(
                                  'Failed to verify OTP: ${responseData["msg"]}');
                            }

                            ShowToastDialog.closeLoader();
                          } catch (e) {
                            // log(e.toString());
                            ShowToastDialog.closeLoader();
                            ShowToastDialog.showToast(e.toString());
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
