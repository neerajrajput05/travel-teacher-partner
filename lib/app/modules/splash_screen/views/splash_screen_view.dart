import 'package:driver/app/modules/splash_screen/controllers/splash_screen_controller.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenController>(
        init: SplashScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppThemData.black,
            body: Container(
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/splash_background.png"), fit: BoxFit.fill)),
              // child: Center(
              //   child: SvgPicture.asset("assets/icon/splash_logo.svg"),
              // ),
            ),
          );
        });
  }
}
