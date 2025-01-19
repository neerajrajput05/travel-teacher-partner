import 'dart:developer';

import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/modules/home/controllers/home_controller.dart';
import 'package:driver/app/modules/home/views/widgets/new_ride_view.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/no_rides_view.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../controllers/my_rides_controller.dart';

class MyRidesView extends GetView<MyRidesController> {
  MyRidesView({super.key});
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: MyRidesController(),
        dispose: (state) {
          FireStoreUtils().closeStream();
          FireStoreUtils().closeCancelledStream();
          FireStoreUtils().closeCompletedStream();
          FireStoreUtils().closeOngoingStream();
          FireStoreUtils().closeRejectedStream();
        },
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme()
                ? AppThemData.black
                : AppThemData.white,
            // appBar: AppBarWithBorder(
            //   title: "My Rides".tr,
            //   bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
            //   isUnderlineShow: false,
            // ),
            body: Obx(
              () => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
                    child: Obx(
                      () => SizedBox(
                        height: 40,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(bottom: 2),
                          children: [
                            // RoundShapeButton(
                            //   title: "New Ride".tr,
                            //   buttonColor: controller.selectedType.value == 0
                            //       ? AppThemData.primary500
                            //       : themeChange.isDarkTheme()
                            //           ? AppThemData.black
                            //           : AppThemData.white,
                            //   buttonTextColor:
                            //       controller.selectedType.value == 0
                            //           ? AppThemData.black
                            //           : themeChange.isDarkTheme()
                            //               ? AppThemData.white
                            //               : AppThemData.black,
                            //   onTap: () {
                            //     controller.selectedType.value = 0;
                            //   },
                            //   size: const Size(120, 38),
                            //   textSize: 12,
                            // ),
                            const SizedBox(width: 10),
                            RoundShapeButton(
                              title: "Ongoing".tr,
                              buttonColor: controller.selectedType.value == 1
                                  ? AppThemData.primary500
                                  : themeChange.isDarkTheme()
                                      ? AppThemData.black
                                      : AppThemData.white,
                              buttonTextColor:
                                  controller.selectedType.value == 1
                                      ? AppThemData.black
                                      : themeChange.isDarkTheme()
                                          ? AppThemData.white
                                          : AppThemData.black,
                              onTap: () {
                                controller.getOngoingRides();
                                controller.selectedType.value = 1;
                              },
                              size: const Size(120, 38),
                              textSize: 12,
                            ),
                            const SizedBox(width: 10),
                            RoundShapeButton(
                              title: "Completed".tr,
                              buttonColor: controller.selectedType.value == 2
                                  ? AppThemData.primary500
                                  : themeChange.isDarkTheme()
                                      ? AppThemData.black
                                      : AppThemData.white,
                              buttonTextColor:
                                  controller.selectedType.value == 2
                                      ? AppThemData.black
                                      : (themeChange.isDarkTheme()
                                          ? AppThemData.white
                                          : AppThemData.black),
                              onTap: () {
                                controller.getCompletedrides();
                                controller.selectedType.value = 2;
                              },
                              size: const Size(120, 38),
                              textSize: 12,
                            ),
                            const SizedBox(width: 10),
                            RoundShapeButton(
                              title: "Cancelled".tr,
                              buttonColor: controller.selectedType.value == 3
                                  ? AppThemData.primary500
                                  : themeChange.isDarkTheme()
                                      ? AppThemData.black
                                      : AppThemData.white,
                              buttonTextColor:
                                  controller.selectedType.value == 3
                                      ? AppThemData.black
                                      : themeChange.isDarkTheme()
                                          ? AppThemData.white
                                          : AppThemData.black,
                              onTap: () {
                                controller.getCanceledRide();
                                controller.selectedType.value = 3;
                              },
                              size: const Size(120, 38),
                              textSize: 12,
                            ),
                            // const SizedBox(width: 10),
                            // RoundShapeButton(
                            //   title: "Rejected".tr,
                            //   buttonColor: controller.selectedType.value == 4
                            //       ? AppThemData.primary500
                            //       : themeChange.isDarkTheme()
                            //           ? AppThemData.black
                            //           : AppThemData.white,
                            //   buttonTextColor:
                            //       controller.selectedType.value == 4
                            //           ? AppThemData.black
                            //           : themeChange.isDarkTheme()
                            //               ? AppThemData.white
                            //               : AppThemData.black,
                            //   onTap: () {
                            //     controller.selectedType.value = 4;
                            //   },
                            //   size: const Size(120, 38),
                            //   textSize: 12,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  if (controller.selectedType.value == 0) ...{
                    if (homeController.isOnline.value == true) ...{
                      StreamBuilder<List<BookingModel>>(
                          stream: FireStoreUtils().getBookings(
                              Constant.currentLocation!.latitude,
                              Constant.currentLocation!.longitude),
                          builder: (context, snapshot) {
                            log("State Ride: ${snapshot.connectionState}");
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Constant.loader();
                            }
                            if (!snapshot.hasData ||
                                (snapshot.data?.isEmpty ?? true)) {
                              return NoRidesView(themeChange: themeChange);
                            } else {
                              return Container(
                                height: Responsive.height(80, context),
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                child: ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    BookingModel bookingModel =
                                        snapshot.data![index];
                                    return NewRideView(
                                      bookingModel: bookingModel,
                                    );
                                  },
                                ),
                              );
                            }
                          })
                    } else ...{
                      Visibility(
                          visible: homeController.isOnline.value == false,
                          child: Column(
                            children: [
                              goOnlineDialog(
                                title: "You're Now Offline".tr,
                                descriptions:
                                    "Please change your status to online to access all features. When offline, you won't be able to access any functionalities."
                                        .tr,
                                img: SvgPicture.asset(
                                  "assets/icon/ic_offline.svg",
                                  height: 58,
                                  width: 58,
                                ),
                                onClick: () async {
                                  await FireStoreUtils.updateDriverUserOnline(
                                      true);
                                  homeController.isOnline.value = true;
                                  homeController.updateCurrentLocation();
                                },
                                string: "Go Online".tr,
                                themeChange: themeChange,
                                context: context,
                              ),
                              const SizedBox(height: 20),
                            ],
                          )),
                    }
                  } else if (controller.selectedType.value == 1) ...{
                    Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.ongoingRideList.length,
                        itemBuilder: (context, index) {
                          BookingModel bookingModel =
                              controller.ongoingRideList[index];
                          return NewRideView(
                            bookingModel: bookingModel,
                          );
                        },
                      );
                    }),
                  } else if (controller.selectedType.value == 2) ...{
                    Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.completedRideList.length,
                        itemBuilder: (context, index) {
                          BookingModel bookingModel =
                              controller.completedRideList[index];
                          return NewRideView(
                            bookingModel: bookingModel,
                          );
                        },
                      );
                    }),
                  } else if (controller.selectedType.value == 3) ...{
                    Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.canceledRideList.length,
                        itemBuilder: (context, index) {
                          BookingModel bookingModel =
                              controller.canceledRideList[index];
                          return NewRideView(
                            bookingModel: bookingModel,
                          );
                        },
                      );
                    }),
                  } else if (controller.selectedType.value == 4) ...{
                    StreamBuilder<List<BookingModel>>(
                        stream: FireStoreUtils().getRejectedBookings(),
                        builder: (context, snapshot) {
                          log("State Rejected: ${snapshot.connectionState}");
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Constant.loader();
                          }
                          if (!snapshot.hasData ||
                              (snapshot.data?.isEmpty ?? true)) {
                            return NoRidesView(themeChange: themeChange);
                          } else {
                            return Container(
                              height: Responsive.height(80, context),
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                              child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  BookingModel bookingModel =
                                      snapshot.data![index];
                                  return NewRideView(
                                    bookingModel: bookingModel,
                                  );
                                },
                              ),
                            );
                          }
                        }),
                  }
                ],
              ),
            ),
          );
        });
  }
}

goOnlineDialog({
  required BuildContext context,
  required String title,
  required descriptions,
  required string,
  required Widget img,
  required Function() onClick,
  required DarkThemeProvider themeChange,
  Color? buttonColor,
  Color? buttonTextColor,
}) {
  return Container(
    padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
    decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: themeChange.isDarkTheme() ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(20)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        img,
        const SizedBox(
          height: 20,
        ),
        Visibility(
          visible: title.isNotEmpty,
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: themeChange.isDarkTheme()
                  ? AppThemData.grey25
                  : AppThemData.grey950,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Visibility(
          visible: descriptions.isNotEmpty,
          child: Text(
            descriptions,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: themeChange.isDarkTheme()
                  ? AppThemData.grey25
                  : AppThemData.grey950,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  onClick();
                },
                child: Container(
                  width: Responsive.width(100, context),
                  height: 45,
                  decoration: ShapeDecoration(
                    color: buttonColor ?? AppThemData.primary500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(200),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        string.toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: buttonTextColor ?? AppThemData.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}
