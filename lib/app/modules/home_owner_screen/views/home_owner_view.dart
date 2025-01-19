import 'package:driver/app/modules/create_own_driver/views/create_driver_view.dart';
import 'package:driver/app/modules/home_owner_screen/controllers/home_owner_controller.dart';
import 'package:driver/app/modules/home_owner_screen/driver_detail_view.dart';
import 'package:driver/app/modules/home_owner_screen/views/widget/owner_drawer.dart';
import 'package:driver/app/modules/html_view_screen/views/html_view_screen_view.dart';
import 'package:driver/app/modules/language/views/language_view.dart';
import 'package:driver/app/modules/my_bank/views/my_bank_view.dart';
import 'package:driver/app/modules/my_rides/views/my_rides_view.dart';
import 'package:driver/app/modules/notifications/views/notifications_view.dart';
import 'package:driver/app/modules/support_screen/views/support_screen_view.dart';
import 'package:driver/app/modules/verify_documents/views/verify_documents_view.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeOwnerView extends GetView<HomeOwnerController> {
  const HomeOwnerView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<HomeOwnerController>(
      init: HomeOwnerController(),
      dispose: (state) {
        FireStoreUtils().closeStream();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
          appBar: buildAppBar(themeChange),
          drawer: const OwnerDrawerView(),
          body: Obx(() => buildBody(controller, themeChange)),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => const CreateOwnDriver());
            },
            elevation: 3,
            child: const Text(
              "+",
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      },
    );
  }

  AppBar buildAppBar(DarkThemeProvider themeChange) {
    return AppBar(
      shape: Border(
        bottom: BorderSide(
          color: themeChange.isDarkTheme()
              ? AppThemData.grey800
              : AppThemData.grey100,
          width: 1,
        ),
      ),
      title: buildAppBarTitle(themeChange),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Get.to(() => const NotificationsView());
          },
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }

  Row buildAppBarTitle(DarkThemeProvider themeChange) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/icon/logo_only.svg"),
        const SizedBox(width: 10),
        InkWell(
          onTap: () => controller.getListOfDriver(),
          child: Text(
            'MyTaxi'.tr,
            style: GoogleFonts.inter(
              color: themeChange.isDarkTheme()
                  ? AppThemData.white
                  : AppThemData.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 20,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              " as owner",
              style: GoogleFonts.inter(
                color: themeChange.isDarkTheme()
                    ? AppThemData.white
                    : AppThemData.black,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBody(
      HomeOwnerController controller, DarkThemeProvider themeChange) {
    final drawerIndex = controller.drawerIndex.value;

    if (drawerIndex == 1) return MyRidesView();
    if (drawerIndex == 3) return const MyBankView();
    if (drawerIndex == 4) return const VerifyDocumentsView(isFromDrawer: true);
    if (drawerIndex == 5) return const SupportScreenView();
    if (drawerIndex == 6) {
      return HtmlViewScreenView(
          title: "Privacy & Policy", htmlData: Constant.privacyPolicy);
    }
    if (drawerIndex == 7) {
      return HtmlViewScreenView(
          title: "Terms & Condition", htmlData: Constant.termsAndConditions);
    }
    if (drawerIndex == 8) return const LanguageView();
    if (controller.isLoading.value) return Constant.loader();

    return buildMainContent(controller, themeChange);
  }

  Widget buildMainContent(
      HomeOwnerController controller, DarkThemeProvider themeChange) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => controller.getListOfDriver(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.refresh_rounded),
                    Text("Refresh"),
                  ],
                ),
              ),
            ),
            const Divider(),
            Obx(() {
              if (controller.driverList.isEmpty) {
                return const Center(
                  child: Column(
                    children: [
                      Icon(Icons.no_accounts_sharp, size: 80),
                      Text("No driver found"),
                    ],
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.driverList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Image.asset(
                          "assets/images/create_driver.png",
                          width: 40,
                          height: 40,
                        ),
                        title: Text(
                          controller.driverList[index].name ?? 'Unknown',
                          style: const TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(controller.driverList[index].phone ?? '',
                            style: const TextStyle(fontSize: 14)),
                        onTap: () {
                          Get.to(() => DriverDetailsView(
                              driver: controller.driverList[index]));
                        },
                      ),
                      const Divider(),
                    ],
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
