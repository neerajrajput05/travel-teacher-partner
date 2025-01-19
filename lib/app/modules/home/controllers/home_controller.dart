import 'dart:async';
import 'dart:developer';

import 'package:driver/app/services/api_service.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/location_lat_lng.dart';
import 'package:driver/app/models/positions_model.dart';
import 'package:driver/app/models/review_customer_model.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeController extends GetxController {
  RxString profilePic = Constant.profileConstant.obs;
  RxString name = ''.obs;
  RxString phoneNumber = ''.obs;
  RxBool isOnline = false.obs;
  RxBool isLoading = false.obs;
  Rx<DriverUserModel> userModel = DriverUserModel().obs;
  RxList<ReviewModel> reviewList = <ReviewModel>[].obs;
  RxInt drawerIndex = 0.obs;
  List<Color> colorList = [
    AppThemData.bookingNew,
    AppThemData.bookingOngoing,
    AppThemData.bookingCompleted,
    AppThemData.bookingRejected,
    AppThemData.bookingCancelled
  ];
  RxMap<String, double> dataMap = <String, double>{
    "New": 0,
    "Ongoing": 0,
    "Completed": 0,
    "Rejected": 0,
    "Cancelled": 0,
  }.obs;
  RxList color = [
    AppThemData.secondary50,
    AppThemData.success50,
    AppThemData.danger50,
    AppThemData.info50
  ].obs;
  RxList colorDark = [
    AppThemData.secondary950,
    AppThemData.success950,
    AppThemData.danger950,
    AppThemData.info950
  ].obs;

  RxInt totalRides = 0.obs;
  late IO.Socket socket;

  late Timer _timer;

  // RxInt newRides = 0.obs;
  // RxInt ongoingRides = 0.obs;
  // RxInt completedRides = 0.obs;
  // RxInt rejectedRides = 0.obs;

  @override
  void onInit() {
    getFcm();
    setLocation();
    getUserData();
    getChartData();
    updateCurrentLocation();
    getRideRequestt();

    //  _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   getRequest();
    // });

    // initializeSocket();
    super.onInit();
  }



  Future<void> getRideRequestt() async {
    Map<String, dynamic> userModel = await getProfile();
    if (userModel.isNotEmpty) {
      name.value = userModel["name"] ?? '';
      phoneNumber.value =
          (userModel["country_code"] ?? '') + (userModel["phone"] ?? '');
    }
  }

  getUserData() async {
    isLoading.value = true;
    await FireStoreUtils.getDriverUserProfile(FireStoreUtils.getCurrentUid())
        .then((value) {
      if (value != null) {
        userModel.value = value;
      }
    });
    checkActiveStatus();
    Constant.userModel = userModel.value;
    isOnline.value = userModel.value.isOnline ?? false;
    profilePic.value = (userModel.value.profilePic ?? "").isNotEmpty
        ? userModel.value.profilePic ?? Constant.profileConstant
        : Constant.profileConstant;
    name.value = userModel.value.fullName ?? '';
    phoneNumber.value = (userModel.value.countryCode ?? '') +
        (userModel.value.phoneNumber ?? '');
    await FireStoreUtils.getReviewList(userModel.value).then((value) {
      if (value != null) {
        reviewList.addAll(value);
      }
    });
    log("=======> Get User Data");
  }

  checkActiveStatus() async {
    DriverUserModel? driverUserModel =
        await FireStoreUtils.getDriverUserProfile(
            FireStoreUtils.getCurrentUid());
    if (driverUserModel!.isActive == false) {
      Get.defaultDialog(
          titlePadding: const EdgeInsets.only(top: 16),
          title: "Account Disabled",
          middleText:
              "Your account has been disabled. Please contact the administrator.",
          titleStyle:
              GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
          barrierDismissible: false,
          onWillPop: () async {
            SystemNavigator.pop();
            return false;
          });
    }
    // log("=======> Check Active Status");
  }

  getChartData() async {
    totalRides.value =
        int.parse((await FireStoreUtils.getTotalRide()).toString());
    int newRide = int.parse((await FireStoreUtils.getNewRide()).toString());
    int onGoingRide =
        int.parse((await FireStoreUtils.getOngoingRide()).toString());
    int completedRide =
        int.parse((await FireStoreUtils.getCompletedRide()).toString());
    int rejectedRide =
        int.parse((await FireStoreUtils.getRejectedRide()).toString());
    int cancelledRide =
        int.parse((await FireStoreUtils.getCancelledRide()).toString());
    // log(" +++++++++");
    totalRides.value = totalRides.value + rejectedRide;
    dataMap.value = {
      "New": newRide.toDouble(),
      "Ongoing": onGoingRide.toDouble(),
      "Completed": completedRide.toDouble(),
      "Rejected": rejectedRide.toDouble(),
      "Cancelled": cancelledRide.toDouble(),
    };
    // isLoading.value = false;
    log("=======> Get Chart Data");
  }

  getFcm() async {
    Rx<DriverUserModel> userModel = DriverUserModel().obs;
    await FireStoreUtils.getDriverUserProfile(FireStoreUtils.getCurrentUid())
        .then((value) async {
      if (value != null) {
        userModel.value = value;
        userModel.value.fcmToken = await NotificationService.getToken();
        await FireStoreUtils.updateDriverUser(userModel.value);
      }
    });
    log("=======> Get FCM");
  }

  Location location = Location();

  updateCurrentLocation() async {
    isLoading.value = true;
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.granted) {
      location.enableBackgroundMode(enable: true);
      location.changeSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter:
              double.parse(Constant.driverLocationUpdate.toString()),
          interval: 2000);
      location.onLocationChanged.listen((locationData) async {
        log("------>");
        log(locationData.toString());
        Constant.currentLocation = LocationLatLng(
            latitude: locationData.latitude, longitude: locationData.longitude);

        DriverUserModel driverUserModel = Preferences.userModel!;
        if (driverUserModel.isOnline == true) {
          driverUserModel.location = LocationLatLng(
              latitude: locationData.latitude,
              longitude: locationData.longitude);
          GeoFirePoint position = GeoFlutterFire().point(
              latitude: locationData.latitude!,
              longitude: locationData.longitude!);

          driverUserModel.position =
              Positions(geoPoint: position.geoPoint, geohash: position.hash);
          driverUserModel.rotation = locationData.heading;
          await FireStoreUtils.updateDriverUser(driverUserModel);
        }

        isLoading.value = false;
        log("------>1");
      });
      log("------>2");
    } else {
      location.requestPermission().then((permissionStatus) {
        log("------>3");
        if (permissionStatus == PermissionStatus.granted) {
          location.enableBackgroundMode(enable: true);
          location.changeSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter:
                  double.parse(Constant.driverLocationUpdate.toString()),
              interval: 2000);
          location.onLocationChanged.listen((locationData) async {
            Constant.currentLocation = LocationLatLng(
                latitude: locationData.latitude,
                longitude: locationData.longitude);
            log("------>4");
            await FireStoreUtils.getDriverUserProfile(
                    FireStoreUtils.getCurrentUid())
                .then((value) async {
              DriverUserModel driverUserModel = value!;
              if (driverUserModel.isOnline == true) {
                driverUserModel.location = LocationLatLng(
                    latitude: locationData.latitude,
                    longitude: locationData.longitude);
                driverUserModel.rotation = locationData.heading;
                GeoFirePoint position = GeoFlutterFire().point(
                    latitude: locationData.latitude!,
                    longitude: locationData.longitude!);

                driverUserModel.position = Positions(
                    geoPoint: position.geoPoint, geohash: position.hash);

                await FireStoreUtils.updateDriverUser(driverUserModel);
              }
            });
          });
        }
        log("------>5");
        isLoading.value = false;
      });
      log("------>6");
    }
    update();
    log("=======> Update Location");
  }

  void initializeSocket() {
    // Configure the socket
    socket = IO.io('https://travelteachergroup.com:8081', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Connect to the socket
    socket.connect();

    // Listen for responses from the server
    socket.on('/driver/passenger/ride/request', (data) {
      // Handle the response data
      print('Received ride request response: $data');
      // You can update your state or perform actions based on the response
    });

    // Optionally, handle connection events
    socket.onConnect((_) {
      print('Connected to socket');
      // Emit a request to get ride requests
      socket.emit('getRideRequest');
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket');
    });
  }

  void setLocation() async {
    Location location = Location();
    LocationData data = await location.getLocation();

    Preferences.driverLat = data.latitude as double;
    Preferences.driverLong = data.longitude as double;

    try {
      await updateCurrentLocationAPI(
          data.latitude.toString(), data.longitude.toString());
    } catch (e) {
      print(e);
    }
  }
}
