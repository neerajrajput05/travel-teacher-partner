import 'package:driver/app/modules/create_drive_screen/controllers/create_driver_controller.dart';
import 'package:driver/app/modules/login_owner_screen/views/login_owner_view.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/country_code_selector_view.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/constant_widgets/text_field_with_title.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/validate_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateDriverView extends StatelessWidget {
  const CreateDriverView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<CreateDriverController>(
        init: CreateDriverController(),
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
              body: SafeArea(
                child: Container(
                  width: Responsive.width(100, context),
                  height: Responsive.height(100, context),
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: SingleChildScrollView(
                    child: Form(
                      key: controller.formKey.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: Responsive.height(2, context),
                                  bottom: 10),
                              child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => const LoginOwnerView(
                                          isOwner: true,
                                        ));
                                  },
                                  child: const Text("Login")),
                            ),
                          ),
                          Text(
                            "Register as a owner".tr,
                            style: GoogleFonts.inter(
                                fontSize: 24,
                                color: themeChange.isDarkTheme()
                                    ? AppThemData.white
                                    : AppThemData.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "Create an account as driver owner.".tr,
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                color: themeChange.isDarkTheme()
                                    ? AppThemData.white
                                    : AppThemData.black,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 36),
                          TextFieldWithTitle(
                            title: "Full Name".tr,
                            hintText: "Enter Full Name".tr,
                            prefixIcon:
                                const Icon(Icons.person_outline_rounded),
                            controller: controller.nameController,
                            validator: (value) =>
                                value != null && value.isNotEmpty
                                    ? null
                                    : 'This field required'.tr,
                          ),
                          const SizedBox(height: 20),
                          TextFieldWithTitle(
                            title: "Phone Number".tr,
                            hintText: "Enter Phone Number".tr,
                            maxLength: 10,
                            prefixIcon: CountryCodeSelectorView(
                              isCountryNameShow: false,
                              countryCodeController:
                                  controller.countryCodeController,
                              isEnable: controller.loginType.value !=
                                  Constant.phoneLoginType,
                              onChanged: (value) {
                                controller.countryCodeController.text =
                                    value.dialCode.toString();
                              },
                            ),
                            validator: (value) => validateMobile(value,
                                controller.countryCodeController.value.text),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                            controller: controller.phoneNumberController,
                            isEnable: controller.loginType.value !=
                                Constant.phoneLoginType,
                          ),
                          TextFieldWithTitle(
                            title: "Email Address",
                            hintText: "Enter Email Address",
                            prefixIcon: const Icon(Icons.email_outlined),
                            keyboardType: TextInputType.emailAddress,
                            controller: controller.emailController,
                            isEnable: true,
                            validator: (value) =>
                                Constant().validateEmail(value),
                          ),
                          const SizedBox(height: 20),
                          TextFieldWithTitle(
                            title: "Password",
                            hintText: "Enter your password",
                            prefixIcon: const Icon(Icons.password),
                            keyboardType: TextInputType.text,
                            controller: controller.passwordController,
                            obscureText: true,
                            isEnable: true,
                          ),
                          const Text(
                            "Password must contain atlest\n. 8 characters\n. 1 uppercase\n. 1 special character\n. 1 numeric",
                            style: TextStyle(fontSize: 10),
                          ),
                          const SizedBox(height: 20),
                          TextFieldWithTitle(
                            title: "Confirm Password",
                            hintText: "Confirm your password",
                            prefixIcon: const Icon(Icons.password),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            controller: controller.confrimpasswordController,
                            isEnable: true,
                          ),
                          const SizedBox(height: 50),
                          Center(
                            child: RoundShapeButton(
                                size: const Size(200, 45),
                                title: "Create".tr,
                                buttonColor: AppThemData.primary500,
                                buttonTextColor: AppThemData.black,
                                onTap: () {
                                  if (controller.formKey.value.currentState!
                                      .validate()) {
                                    if (controller.passwordController.text !=
                                        controller
                                            .confrimpasswordController.text) {
                                      // Show error message
                                      ShowToastDialog.showToast(
                                          "Passwords do not match".tr);
                                    } else {
                                      controller.createDriverAccount();
                                    }
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
