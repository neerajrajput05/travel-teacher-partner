import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/modules/home/views/widgets/collect_money_popup.dart';
import 'package:driver/app/modules/reason_for_cancel/views/reason_for_cancel_view.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/custom_dialog_box.dart';
import 'package:driver/constant_widgets/pick_drop_point_view.dart';
import 'package:driver/constant_widgets/round_shape_button.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InProgressRideView extends StatelessWidget {
  final RideData? bookingModel;

  const InProgressRideView({super.key, this.bookingModel});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InkWell(
      onTap: () {
        //  BookingDetailsController detailsController =
        //     Get.put(BookingDetailsController());
        // detailsController.bookingId.value = bookingModel!.id ?? '';
        // detailsController.bookingModel.value = bookingModel!;
        // Get.to(() => BookingDetailsView(
        //       rideData: bookingModel!,
        //     ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: _buildContainerDecoration(themeChange),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // _buildHeader(themeChange),
            // const SizedBox(height: 12),
            // _buildActionRow(context, themeChange),
            PickDropPointView(
              pickUpAddress: bookingModel?.pickupAddress ?? '',
              dropAddress: bookingModel?.dropoffAddress ?? '',
            ),
            _buildStatusButtons(context, themeChange),
          ],
        ),
      ),
    );
  }

  ShapeDecoration _buildContainerDecoration(DarkThemeProvider themeChange) {
    return ShapeDecoration(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: themeChange.isDarkTheme()
              ? AppThemData.grey800
              : AppThemData.grey100,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildHeader(DarkThemeProvider themeChange) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          bookingModel?.createdAt.toString() ?? "",
          style: GoogleFonts.inter(
            color: themeChange.isDarkTheme()
                ? AppThemData.grey400
                : AppThemData.grey500,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 8),
        _buildSeparator(themeChange),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            bookingModel?.createdAt.toString() ?? "",
            style: GoogleFonts.inter(
              color: themeChange.isDarkTheme()
                  ? AppThemData.grey400
                  : AppThemData.grey500,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.keyboard_arrow_right_sharp,
          color: themeChange.isDarkTheme()
              ? AppThemData.grey400
              : AppThemData.grey500,
        ),
      ],
    );
  }

  Widget _buildSeparator(DarkThemeProvider themeChange) {
    return Container(
      height: 15,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: themeChange.isDarkTheme()
                ? AppThemData.grey800
                : AppThemData.grey100,
          ),
        ),
      ),
    );
  }

  Widget _buildActionRow(BuildContext context, DarkThemeProvider themeChange) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RoundShapeButton(
          title: "Accept Ride",
          buttonColor: AppThemData.blueLight01,
          buttonTextColor: AppThemData.black,
          onTap: () {
            acceptRideAPI(bookingModel?.id ?? "");
          },
          size: const Size(50, 42),
        ),
        const SizedBox(width: 12),
        _buildVehicleInfo(themeChange),
      ],
    );
  }

  Widget _buildVehicleInfo(DarkThemeProvider themeChange) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bookingModel?.vehicleId ?? "",
            style: GoogleFonts.inter(
              color: themeChange.isDarkTheme()
                  ? AppThemData.grey25
                  : AppThemData.grey950,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "Payment is Completed".tr,
            style: GoogleFonts.inter(
              color: themeChange.isDarkTheme()
                  ? AppThemData.grey25
                  : AppThemData.grey950,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButtons(
      BuildContext context, DarkThemeProvider themeChange) {
    if ((bookingModel?.status ?? '') == BookingStatus.bookingPlaced) {
      return _buildBookingPlacedButtons(context, themeChange);
    } else if ((bookingModel?.status ?? '') ==
        BookingStatus.bookingInProgress) {
      return _buildInProgressPlacedButtons(context, themeChange);
    } else if (bookingModel!.driverId == Preferences.userModel!.id!) {
      return _buildBookingAcceptedButtons(context, themeChange);
    }
    return const SizedBox
        .shrink(); // Return an empty widget if no buttons are needed
  }

  Widget _buildInProgressPlacedButtons(
      BuildContext context, DarkThemeProvider themeChange) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Preferences.openMapWithDirections(
                destinationLatitude: bookingModel!.dropoffLocation
                    .coordinates![0], // Example latitude (San Francisco)
                destinationLongitude:
                    bookingModel!.dropoffLocation.coordinates![1],
                startLatitude: Preferences.driverLat,
                startLongitude: Preferences.driverLong);
          },
          child: const Text('Open Drop Location in Map'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundShapeButton(
              title: "Cancel Ride",
              buttonColor: themeChange.isDarkTheme()
                  ? AppThemData.grey900
                  : AppThemData.grey50,
              buttonTextColor: themeChange.isDarkTheme()
                  ? AppThemData.white
                  : AppThemData.black,
              onTap: () {
                Get.to(() => ReasonForCancelView(
                      bookingModel: bookingModel!,
                    ));
              },
              size: Size(MediaQuery.of(context).size.width / 2 - 50, 42),
            ),
            RoundShapeButton(
              title: "Complete Ride",
              buttonColor: AppThemData.primary500,
              buttonTextColor: AppThemData.black,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialogBox(
                        title: "Complete Ride",
                        descriptions:
                            "Are you sure you want to complete this ride request?",
                        img: Image.asset(
                          "assets/icon/ic_green_right.png",
                          height: 58,
                          width: 58,
                        ),
                        positiveClick: () async {
                          // Navigator.pop(context);

                          bool canceled = await completeRide(bookingModel!.id);

                          if (canceled) {
                            Navigator.pop(context);
                            ShowToastDialog.showToast('Ride Completed');
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CollectMoneyPopup(
                                      amount:
                                          bookingModel!.fareAmount.toString());
                                });
                          } else {
                            ShowToastDialog.showToast(
                                'Failed to Complete Ride');
                            Navigator.pop(context);
                          }

                          // Navigator.pop(context);
                        },
                        negativeClick: () {
                          Navigator.pop(context);
                        },
                        positiveString: "Confirm",
                        negativeString: "Cancel",
                        themeChange: themeChange);
                  },
                );

                // Preferences.rideModule = bookingModel;
                // Get.toNamed(Routes.ASK_FOR_OTP,
                //     arguments: {"bookingModel": bookingModel!});
              },
              size: Size(MediaQuery.of(context).size.width / 2 - 50, 42),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildBookingPlacedButtons(
      BuildContext context, DarkThemeProvider themeChange) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RoundShapeButton(
          title: "Cancel Ride",
          buttonColor: AppThemData.danger500,
          buttonTextColor: AppThemData.white,
          onTap: () {
            _showCancelDialog(context, themeChange);
          },
          size: const Size(10, 42),
        ),
        RoundShapeButton(
          title: "Accept".tr,
          buttonColor: AppThemData.primary500,
          buttonTextColor: AppThemData.black,
          onTap: () {
            if (double.parse(Constant.userModel!.walletAmount.toString()) >
                double.parse(Constant.minimumAmountToAcceptRide.toString())) {
              showDialog(
                context: context,
                builder: (context) {
                  return CustomDialogBox(
                      title: "Confirm Ride Request",
                      descriptions:
                          "Are you sure you want to accept this ride request? Once confirmed, you will be directed to the next step to proceed with the ride.",
                      img: Image.asset(
                        "assets/icon/ic_green_right.png",
                        height: 58,
                        width: 58,
                      ),
                      positiveClick: () {
                        Navigator.pop(context);
                      },
                      negativeClick: () {
                        Navigator.pop(context);
                      },
                      positiveString: "Confirm",
                      negativeString: "Cancel",
                      themeChange: themeChange);
                },
              );
            } else {
              ShowToastDialog.showToast(
                  "You do not have sufficient wallet balance to accept the ride, as the minimum amount required is ${Constant.amountShow(amount: Constant.minimumAmountToAcceptRide)}.");
            }
          },
          size: const Size(50, 42),
        )
      ],
    );
  }

  Widget _buildBookingAcceptedButtons(
      BuildContext context, DarkThemeProvider themeChange) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Preferences.openMapWithDirections(
                destinationLatitude: bookingModel!.dropoffLocation
                    .coordinates![0], // Example latitude (San Francisco)
                destinationLongitude:
                    bookingModel!.dropoffLocation.coordinates![1],
                startLatitude: Preferences.driverLat,
                startLongitude: Preferences.driverLong);
          },
          child: const Text('Open PickUp Location in Map'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundShapeButton(
              title: "Cancel Ride",
              buttonColor: themeChange.isDarkTheme()
                  ? AppThemData.grey900
                  : AppThemData.grey50,
              buttonTextColor: themeChange.isDarkTheme()
                  ? AppThemData.white
                  : AppThemData.black,
              onTap: () {
                Get.to(() => ReasonForCancelView(
                      bookingModel: bookingModel!,
                    ));
              },
              size: Size(MediaQuery.of(context).size.width / 2 - 50, 42),
            ),
            RoundShapeButton(
              title: "Pickup",
              buttonColor: AppThemData.primary500,
              buttonTextColor: AppThemData.black,
              onTap: () {
                Preferences.rideModule = bookingModel;
                Get.toNamed(Routes.ASK_FOR_OTP,
                    arguments: {"bookingModel": bookingModel!});
              },
              size: Size(MediaQuery.of(context).size.width / 2 - 50, 42),
            )
          ],
        )
      ],
    );
  }

  void _showCancelDialog(BuildContext context, DarkThemeProvider themeChange) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
              themeChange: themeChange,
              title: "Cancel Ride".tr,
              negativeButtonColor: themeChange.isDarkTheme()
                  ? AppThemData.grey950
                  : AppThemData.grey50,
              negativeButtonTextColor: themeChange.isDarkTheme()
                  ? AppThemData.grey50
                  : AppThemData.grey950,
              positiveButtonColor: AppThemData.danger500,
              positiveButtonTextColor: AppThemData.grey25,
              descriptions: "Are you sure you want cancel this ride?".tr,
              positiveString: "Cancel Ride".tr,
              negativeString: "Cancel".tr,
              positiveClick: () async {
                Navigator.pop(context);
                bool value = await cancelRide(bookingModel!.id, "");

                if (value == true) {
                  ShowToastDialog.showToast("Ride cancelled successfully!");

                  Navigator.pop(context);
                } else {
                  ShowToastDialog.showToast("Something went wrong!");
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
  }
}
