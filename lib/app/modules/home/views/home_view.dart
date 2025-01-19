// Flutter & Dart packages
import 'package:driver/app/modules/home/views/widgets/drawer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Third-party packages
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// Project modules
import 'package:driver/app/modules/home/views/widgets/active_ride_view.dart';
import 'package:driver/app/modules/home/views/widgets/in_progress_ride_view.dart';
import 'package:driver/app/modules/home/views/widgets/new_ride_view.dart';
import 'package:driver/app/modules/html_view_screen/views/html_view_screen_view.dart';
import 'package:driver/app/modules/language/views/language_view.dart';
import 'package:driver/app/modules/my_bank/views/my_bank_view.dart';
import 'package:driver/app/modules/my_rides/views/my_rides_view.dart';
import 'package:driver/app/modules/notifications/views/notifications_view.dart';
import 'package:driver/app/modules/support_screen/views/support_screen_view.dart';
import 'package:driver/app/modules/verify_documents/views/verify_documents_view.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';

// Controllers
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<HomeController>(
      init: HomeController(),
      dispose: (state) => FireStoreUtils().closeStream(),
      builder: (controller) => Scaffold(
        backgroundColor:
            themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
        appBar: _buildAppBar(themeChange),
        drawer: const DrawerView(),
        body: Obx(() => _buildBody(controller, themeChange)),
      ),
    );
  }

  AppBar _buildAppBar(DarkThemeProvider themeChange) {
    return AppBar(
      shape: Border(
        bottom: BorderSide(
          color: themeChange.isDarkTheme()
              ? AppThemData.grey800
              : AppThemData.grey100,
          width: 1,
        ),
      ),
      title: const _AppBarTitle(),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => Get.to(() => const NotificationsView()),
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }

  Widget _buildBody(HomeController controller, DarkThemeProvider themeChange) {
    // if (controller.isLoading.value) return Constant.loader();

    switch (controller.drawerIndex.value) {
      case 1:
        return MyRidesView();
      case 3:
        return const MyBankView();
      case 4:
        return const VerifyDocumentsView(isFromDrawer: true);
      case 5:
        return const SupportScreenView();
      case 6:
        return HtmlViewScreenView(
          title: "Privacy & Policy",
          htmlData: Constant.privacyPolicy,
        );
      case 7:
        return HtmlViewScreenView(
          title: "Terms & Condition",
          htmlData: Constant.termsAndConditions,
        );
      case 8:
        return const LanguageView();
      default:
        return _buildMainContent(controller, themeChange);
    }
  }

  Widget _buildMainContent(
      HomeController controller, DarkThemeProvider themeChange) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EarningsContainer(controller: controller),
          const SizedBox(height: 16),
          _buildStreamWidgets(controller),
        ],
      ),
    );
  }

  Widget _buildStreamWidgets(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStream(
            getLiveRidesRequest, InProgressRideView.new, 'In Progress Rides'),
        const SizedBox(height: 16),
        _buildStream(
            getActiveRidesRequest, ActiveRideView.new, 'In Progress Rides'),
        const SizedBox(height: 20),
        _buildStream(getRequest, NewRideView.new, 'New Ride'.tr),
      ],
    );
  }

  Widget _buildStream<T>(
    Stream<List<T>> Function() streamFunction,
    Widget Function({required T bookingModel}) viewBuilder,
    String text,
  ) {
    return Column(
      children: [
        StreamBuilder<List<T>>(
          stream: streamFunction(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.isNotEmpty) {
              return Column(
                children: [
                  Text(text,
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  Column(
                    children: snapshot.data!
                        .map((data) => viewBuilder(bookingModel: data))
                        .toList(),
                  ),
                ],
              );
            }
            return const SizedBox
                .shrink(); // Hide completely if no bookings are available
          },
        )
      ],
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {}, // Placeholder for action
          child: SizedBox(
              height: 30,
              width: 30,
              child: Image.asset("assets/icon/app_icon.png")),
        ),
        const SizedBox(width: 10),
        Text(
          'Travel Teacher'.tr,
          style: GoogleFonts.inter(
            color: themeChange.isDarkTheme()
                ? AppThemData.white
                : AppThemData.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        // SizedBox(
        //   height: 20,
        //   child: Align(
        //     alignment: Alignment.bottomLeft,
        //     child: Text(
        //       " as driver",
        //       style: GoogleFonts.inter(
        //         color: themeChange.isDarkTheme()
        //             ? AppThemData.white
        //             : AppThemData.black,
        //         fontSize: 12,
        //         fontWeight: FontWeight.w700,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class _EarningsContainer extends StatelessWidget {
  final HomeController controller;

  const _EarningsContainer({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: ShapeDecoration(
        image: const DecorationImage(
          image: AssetImage("assets/images/top_banner_background.png"),
          fit: BoxFit.cover,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Earnings'.tr,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 12)),
              const SizedBox(height: 6),
              Text(
                Constant.amountShow(
                  amount: (controller.userModel.value.totalEarning ?? '0.0')
                      .toString(),
                ),
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SvgPicture.asset("assets/icon/ic_hand_currency.svg",
              width: 52, height: 52),
        ],
      ),
    );
  }
}
