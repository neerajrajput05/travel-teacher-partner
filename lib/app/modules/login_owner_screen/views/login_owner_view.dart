import 'package:driver/app/modules/login_owner_screen/controllers/login_owner_controller.dart';
import 'package:driver/app/modules/reset_owner_password/views/reset_owner_pass_view.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/text_field_with_title.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginOwnerView extends StatelessWidget {
  final bool isOwner;
  const LoginOwnerView({super.key, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<LoginOnwerController>(
        init: LoginOnwerController(),
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
                                    Get.back();
                                  },
                                  child: const Text("Back")),
                            ),
                          ),
                          Text(
                            "Login".tr,
                            style: GoogleFonts.inter(
                                fontSize: 24,
                                color: themeChange.isDarkTheme()
                                    ? AppThemData.white
                                    : AppThemData.black,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "Login with registerd Email and Password".tr,
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                color: themeChange.isDarkTheme()
                                    ? AppThemData.white
                                    : AppThemData.black,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 20),
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
                            keyboardType: TextInputType.visiblePassword,
                            controller: controller.passwordController,
                            obscureText: true,
                            isEnable: true,
                            validator: (value) =>
                                Constant().validateRequired(value, "Password"),
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () {
                              Get.to(const ResetOwnerPassView());
                            },
                            child: const Text(
                              "Forget Password",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Center(
                            child: RoundShapeButton(
                                size: const Size(200, 45),
                                title: "Login".tr,
                                buttonColor: AppThemData.primary500,
                                buttonTextColor: AppThemData.black,
                                onTap: () {
                                  if (controller.formKey.value.currentState!
                                      .validate()) {
                                    if (isOwner) {
                                      controller.loginOwnerAccount();
                                    } else {
                                      controller.loginDriverAccount();
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
