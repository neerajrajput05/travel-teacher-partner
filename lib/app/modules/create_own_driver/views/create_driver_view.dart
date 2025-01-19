import 'package:driver/app/modules/create_own_driver/controllers/create_driver_controller.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/country_code_selector_view.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/constant_widgets/text_field_with_title.dart';
import 'package:driver/extension/date_time_extension.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/validate_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateOwnDriver extends StatelessWidget {
  const CreateOwnDriver({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<CreateOwnDriverController>(
        init: CreateOwnDriverController(),
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
                          Padding(
                            padding: EdgeInsets.only(
                                top: Responsive.height(5, context), bottom: 32),
                            child: Center(
                                child: SvgPicture.asset(
                                    themeChange.isDarkTheme()
                                        ? "assets/icon/taxi.png"
                                        : "assets/icon/taxi.png")),
                          ),
                          Text(
                            "Add Driver".tr,
                            style: GoogleFonts.inter(
                                fontSize: 24,
                                color: themeChange.isDarkTheme()
                                    ? AppThemData.white
                                    : AppThemData.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "Enter your driver details".tr,
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                color: themeChange.isDarkTheme()
                                    ? AppThemData.white
                                    : AppThemData.black,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 36),
                          TextFieldWithTitle(
                            title: "Driver Name".tr,
                            hintText: "Enter driver full name".tr,
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
                            title: "Driver Phone Number".tr,
                            hintText: "Enter driver phone number".tr,
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
                          InkWell(
                            onTap: () async {
                              DateTime? datetime =
                                  await Constant.selectDateOfBirth(
                                      context, false);
                              controller.dobController.text =
                                  datetime!.dateMonthYear();
                            },
                            child: TextFieldWithTitle(
                              title: "Date of Birth".tr,
                              hintText: "Enter Date of Birth".tr,
                              keyboardType: TextInputType.text,
                              controller: controller.dobController,
                              suffixIcon: const Icon(
                                Icons.calendar_month_outlined,
                                size: 20,
                              ),
                              isEnable: false,
                              validator: (value) =>
                                  value != null && value.isNotEmpty
                                      ? null
                                      : 'This field required'.tr,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFieldWithTitle(
                            title: "Password".tr,
                            hintText: "Enter Password".tr,
                            obscureText: true,
                            prefixIcon:
                                const Icon(Icons.person_outline_rounded),
                            controller: controller.passwordController,
                          ),
                          const Text(
                            "Password must contain atlest\n. 8 characters\n. 1 uppercase\n. 1 special character\n. 1 numeric",
                            style: TextStyle(fontSize: 10),
                          ),
                          const SizedBox(height: 20),
                          TextFieldWithTitle(
                            title: "Confirm Password",
                            hintText: "Confirm your password",
                            obscureText: true,
                            prefixIcon:
                                const Icon(Icons.person_outline_rounded),
                            controller: controller.confirmPassController,
                          ),
                          const SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gender".tr,
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: themeChange.isDarkTheme()
                                        ? AppThemData.white
                                        : AppThemData.grey950,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: controller.selectedGender.value,
                                  activeColor: AppThemData.primary500,
                                  onChanged: (value) {
                                    controller.selectedGender.value =
                                        value ?? 1;
                                    // _radioVal = 'male';
                                  },
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.selectedGender.value = 1;
                                  },
                                  child: Text(
                                    'Male'.tr,
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color:
                                            controller.selectedGender.value == 1
                                                ? themeChange.isDarkTheme()
                                                    ? AppThemData.white
                                                    : AppThemData.grey950
                                                : AppThemData.grey500,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Radio(
                                  value: 2,
                                  groupValue: controller.selectedGender.value,
                                  activeColor: AppThemData.primary500,
                                  onChanged: (value) {
                                    controller.selectedGender.value =
                                        value ?? 2;
                                    // _radioVal = 'female';
                                  },
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.selectedGender.value = 2;
                                  },
                                  child: Text(
                                    'Female'.tr,
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color:
                                            controller.selectedGender.value == 2
                                                ? themeChange.isDarkTheme()
                                                    ? AppThemData.white
                                                    : AppThemData.grey950
                                                : AppThemData.grey500,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                          Center(
                            child: RoundShapeButton(
                                size: const Size(200, 45),
                                title: "Create Driver".tr,
                                buttonColor: AppThemData.primary500,
                                buttonTextColor: AppThemData.black,
                                onTap: () {
                                  if (controller.formKey.value.currentState!
                                      .validate()) {
                                    if (controller.passwordController.text !=
                                        controller.confirmPassController.text) {
                                      ShowToastDialog.showToast(
                                          "Passwords do not match".tr);
                                    } else {
                                      controller.createyourDriverAccount();
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
