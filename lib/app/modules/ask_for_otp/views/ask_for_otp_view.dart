import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:driver/constant_widgets/custom_dialog_box.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/app/modules/otp_screen/views/otp_screen_view.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../controllers/ask_for_otp_controller.dart';

class AskForOtpView extends StatelessWidget {
  final RideData rideData;
  const AskForOtpView({super.key, required this.rideData});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AskForOtpController(),
        builder: (controllrrer) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme()
                ? AppThemData.black
                : AppThemData.white,
            body: Stack(
              children: [
                SizedBox(
                  height: Responsive.height(80, context),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          rideData.pickupLocation.coordinates?[1] ?? 0.0,
                          rideData.pickupLocation.coordinates?[0] ?? 0.0),
                      zoom: 5,
                    ),
                    padding: const EdgeInsets.only(
                      top: 22.0,
                    ),
                    polylines: Set<Polyline>.of(controllrrer.polyLines.values),
                    markers: Set<Marker>.of(controllrrer.markers.values),
                    onMapCreated: (GoogleMapController mapController) {
                      controllrrer.mapController = mapController;
                    },
                  ),
                ),
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(16, 45, 16, 10),
                      child: Icon(Icons.arrow_back),
                    )),
                DraggableScrollableSheet(
                  initialChildSize: 0.38,
                  snapSizes: const [0.31, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42],
                  maxChildSize: 0.42,
                  minChildSize: 0.31,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppThemData.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 20),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 5,
                              margin: const EdgeInsets.only(bottom: 29),
                              decoration: ShapeDecoration(
                                color: AppThemData.grey200,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                            Center(
                              child: Image.asset(
                                "assets/icon/gif_ask_otp.gif",
                                height: 76.0,
                                width: 76.0,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: Text(
                                'Do you want to start this Ride?'.tr,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: AppThemData.grey950,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              'Ask the customer for an OTP so that you can start this ride'
                                  .tr,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: AppThemData.grey950,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RoundShapeButton(
                                  title: "Cancel".tr,
                                  buttonColor: AppThemData.grey50,
                                  buttonTextColor: AppThemData.black,
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomDialogBox(
                                              themeChange: themeChange,
                                              title: "Cancel Ride".tr,
                                              negativeButtonColor:
                                                  themeChange.isDarkTheme()
                                                      ? AppThemData.grey950
                                                      : AppThemData.grey50,
                                              negativeButtonTextColor:
                                                  themeChange.isDarkTheme()
                                                      ? AppThemData.grey50
                                                      : AppThemData.grey950,
                                              positiveButtonColor:
                                                  AppThemData.danger500,
                                              positiveButtonTextColor:
                                                  AppThemData.grey25,
                                              descriptions:
                                                  "Are you sure you want cancel this ride?"
                                                      .tr,
                                              positiveString: "Cancel Ride".tr,
                                              negativeString: "Cancel".tr,
                                              positiveClick: () async {
                                                Navigator.pop(context);
                                                bool value = await cancelRide(
                                                    rideData.id,"");

                                                if (value == true) {
                                                  ShowToastDialog.showToast(
                                                      "Ride cancelled successfully!");

                                                  // await SendNotification
                                                  //     .sendOneNotification(
                                                  //         type: "order",
                                                  //         token: bookingModel!.tok
                                                  //             .toString(),
                                                  //         title: 'Your Ride is Rejected',
                                                  //         customerId: receiverUserModel.id,
                                                  //         senderId: FireStoreUtils
                                                  //             .getCurrentUid(),
                                                  //         bookingId:
                                                  //             bookingModel!.id.toString(),
                                                  //         driverId: bookingModel!.driverId
                                                  //             .toString(),
                                                  //         body:
                                                  //             'Your ride #${bookingModel!.id.toString().substring(0, 4)} has been Rejected by Driver.',
                                                  //         // body: 'Your ride has been rejected by ${driverModel!.fullName}.',
                                                  //         payload: playLoad);

                                                  Navigator.pop(context);
                                                } else {
                                                  ShowToastDialog.showToast(
                                                      "Something went wrong!");
                                                  Navigator.pop(context);
                                                }
                                              },
                                              negativeClick: () {
                                                Navigator.pop(context);
                                              },
                                              img: Image.asset(
                                                "assets/icon/ic_close.png",
                                                height: 58,
                                                width: 58,
                                              ));
                                        });
                                  },
                                  size: Size(Responsive.width(43, context), 42),
                                ),
                                RoundShapeButton(
                                  title: "Ask for OTP".tr,
                                  buttonColor: AppThemData.primary500,
                                  buttonTextColor: AppThemData.black,
                                  onTap: () {
                                    Get.to(OtpScreenView(
                                      bookingModel: rideData,
                                    ));
                                  },
                                  size: Size(Responsive.width(43, context), 42),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}
