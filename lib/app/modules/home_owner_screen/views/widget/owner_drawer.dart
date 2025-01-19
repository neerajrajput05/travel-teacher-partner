import 'dart:developer';

import 'package:driver/app/modules/edit_profile/views/edit_profile_view.dart';
import 'package:driver/app/modules/home/controllers/home_controller.dart';
import 'package:driver/app/modules/login/views/login_view.dart';
import 'package:driver/app/modules/support_screen/views/support_screen_view.dart';
import 'package:driver/constant_widgets/custom_dialog_box.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OwnerDrawerView extends StatelessWidget {
  const OwnerDrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: HomeController(),
        builder: (controller) {
          return Drawer(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Container(
                        color: AppThemData.primary500,
                        padding: const EdgeInsets.only(
                            top: 50, bottom: 30, left: 16, right: 24),
                        child: Obx(
                          () => InkWell(
                            onTap: () async {
                              Get.back();
                              bool? isSave =
                                  await Get.to(() => const EditProfileView());
                              if ((isSave ?? false)) {
                                log("===> ");
                                controller.getUserData();
                                log("=====> ");
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  margin: const EdgeInsets.only(right: 10),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(200),
                                    ),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/driver.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        controller.name.value,
                                        style: GoogleFonts.inter(
                                          color: AppThemData.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        controller.phoneNumber.value,
                                        style: GoogleFonts.inter(
                                          color: AppThemData.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                    onTap: () async {
                                      Get.back();
                                      bool? isSave = await Get.to(
                                          () => const EditProfileView());
                                      if ((isSave ?? false)) {
                                        log("===> ");
                                        controller.getUserData();
                                        log("=====> ");
                                      }
                                    },
                                    child: SvgPicture.asset(
                                        "assets/icon/ic_drawer_edit.svg"))
                              ],
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: SvgPicture.asset(
                          "assets/icon/ic_support.svg",
                          height: 22,
                          colorFilter: ColorFilter.mode(
                              themeChange.isDarkTheme()
                                  ? AppThemData.white
                                  : AppThemData.black,
                              BlendMode.srcIn),
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right_rounded,
                            size: 30),
                        title: Text(
                          'Support'.tr,
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              color: themeChange.isDarkTheme()
                                  ? AppThemData.white
                                  : AppThemData.black,
                              fontWeight: FontWeight.w400),
                        ),
                        onTap: () {
                          Get.back();
                          controller.drawerIndex.value = 5;
                          Get.to(const SupportScreenView());
                        },
                      ),
                      // const Padding(
                      //   padding: EdgeInsets.only(left: 50),
                      //   child: Divider(),
                      // ),
                      // ListTile(
                      //   onTap: () async {
                      //     PackageInfo packageInfo =
                      //         await PackageInfo.fromPlatform();
                      //     String packageName = packageInfo.packageName;
                      //     String appStoreUrl =
                      //         'https://apps.apple.com/app/$packageName';
                      //     String playStoreUrl =
                      //         'https://play.google.com/store/apps/details?id=$packageName';
                      //     if (await canLaunchUrl(Uri.parse(appStoreUrl)) &&
                      //         !Platform.isAndroid) {
                      //       await launchUrl(Uri.parse(appStoreUrl));
                      //     } else if (await canLaunchUrl(
                      //             Uri.parse(playStoreUrl)) &&
                      //         Platform.isAndroid) {
                      //       await launchUrl(Uri.parse(playStoreUrl));
                      //     } else {
                      //       throw 'Could not launch store';
                      //     }
                      //   },
                      //   leading: const Icon(Icons.star_border_rounded),
                      //   trailing: const Icon(Icons.keyboard_arrow_right_rounded,
                      //       size: 30),
                      //   title: Text(
                      //     'Rate Us'.tr,
                      //     style: GoogleFonts.inter(
                      //         fontSize: 16,
                      //         color: themeChange.isDarkTheme()
                      //             ? AppThemData.white
                      //             : AppThemData.black,
                      //         fontWeight: FontWeight.w400),
                      //   ),
                      // ),
                      // const Padding(
                      //   padding: EdgeInsets.only(left: 50),
                      //   child: Divider(),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(16.0),
                      //   child: Text(
                      //     'About'.tr,
                      //     style: GoogleFonts.inter(
                      //         fontSize: 16,
                      //         color: themeChange.isDarkTheme()
                      //             ? AppThemData.white
                      //             : AppThemData.black,
                      //         fontWeight: FontWeight.w600),
                      //   ),
                      // ),
                      // ListTile(
                      //   onTap: () {
                      //     Get.back();
                      //     controller.drawerIndex.value = 6;
                      //     // Get.to(() => HtmlViewScreenView(title: "Privacy & Policy", htmlData: Constant.privacyPolicy));
                      //   },
                      //   leading: const Icon(Icons.privacy_tip_outlined),
                      //   trailing: const Icon(Icons.keyboard_arrow_right_rounded,
                      //       size: 30),
                      //   title: Text(
                      //     'Privacy & Policy'.tr,
                      //     style: GoogleFonts.inter(
                      //         fontSize: 16,
                      //         color: themeChange.isDarkTheme()
                      //             ? AppThemData.white
                      //             : AppThemData.black,
                      //         fontWeight: FontWeight.w400),
                      //   ),
                      // ),
                      // const Padding(
                      //   padding: EdgeInsets.only(left: 50),
                      //   child: Divider(),
                      // ),
                      // ListTile(
                      //   onTap: () {
                      //     Get.back();
                      //     controller.drawerIndex.value = 7;
                      //     // Get.to(() => HtmlViewScreenView(title: "Terms & Condition", htmlData: Constant.termsAndConditions));
                      //   },
                      //   leading: const Icon(Icons.contact_support_outlined),
                      //   trailing: const Icon(Icons.keyboard_arrow_right_rounded,
                      //       size: 30),
                      //   title: Text(
                      //     'Terms & Condition'.tr,
                      //     style: GoogleFonts.inter(
                      //         fontSize: 16,
                      //         color: themeChange.isDarkTheme()
                      //             ? AppThemData.white
                      //             : AppThemData.black,
                      //         fontWeight: FontWeight.w400),
                      //   ),
                      // ),
                      // const Padding(
                      //   padding: EdgeInsets.only(left: 50),
                      //   child: Divider(),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'App Setting'.tr,
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              color: themeChange.isDarkTheme()
                                  ? AppThemData.white
                                  : AppThemData.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.light_mode_outlined),
                        trailing: Switch(
                          value: !themeChange.isDarkTheme(),
                          activeColor: AppThemData.white,
                          activeTrackColor: AppThemData.success,
                          onChanged: (value) {
                            themeChange.darkTheme = value ? 1 : 0;
                          },
                        ),
                        title: Text(
                          'Light Mode'.tr,
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              color: themeChange.isDarkTheme()
                                  ? AppThemData.white
                                  : AppThemData.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 50),
                        child: Divider(),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ListTile(
                    onTap: () {
                      Get.back();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialogBox(
                              themeChange: themeChange,
                              title: "Logout".tr,
                              descriptions:
                                  "Are you sure you want to logout?".tr,
                              positiveString: "Log out".tr,
                              negativeString: "Cancel".tr,
                              positiveClick: () async {
                                Preferences.setFcmToken("");
                                Preferences.setOwnerLoginStatus(false);
                                Preferences.setUserLoginStatus(false);
                                Navigator.pop(context);
                                Get.offAll(const LoginView());
                              },
                              negativeClick: () {
                                Navigator.pop(context);
                              },
                              img: const Icon(
                                Icons.logout,
                                color: Colors.red,
                                size: 40,
                              ),
                            );
                          });
                    },
                    leading: const Icon(
                      Icons.logout,
                      color: AppThemData.error07,
                    ),
                    title: Text(
                      'Logout'.tr,
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          color: AppThemData.error07,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
