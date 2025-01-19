import 'dart:convert';

import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/services/api_service.dart';
import 'package:location/location.dart' as loc;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

String globalToken = '';

class Preferences {
  static const languageCodeKey = "languageCodeKey";
  static const themKey = "themKey";
  static const isFinishOnBoardingKey = "isFinishOnBoardingKey";
  static const String userLoginStatus = "USER_LOGIN_STATUS";
  static const String ownerLoginStatus = "OWNER_LOGIN_STATUS";
  static const String docVerifyStatus = "DOC_VERIFY_STATUS";
  static const String fcmToken = "FCM_TOKEN";
  static String globalToken = "";
  static double driverLat = 0, driverLong = 0;
  static RideData? rideModule;
  static Driver? driverModel;
  static DriverUserModel? userModel;

  static Future<bool> getBoolean(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(key) ?? false;
  }

  static Future<void> setBoolean(String key, bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(key, value);
  }

  static Future<String> getString(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key) ?? "";
  }

  static Future<void> setString(String key, String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }

  static Future<int> getInt(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(key) ?? 0;
  }

  static Future<void> setInt(String key, int value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt(key, value);
  }

  static Future<void> clearSharPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  static Future<void> clearKeyData(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove(key);
  }

  static Future<String> getFcmToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    globalToken = pref.getString(fcmToken) ?? "";
    return globalToken;
  }

  static Future<void> setFcmToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    globalToken = token;
    await pref.setString(fcmToken, token);
  }

  static Future<void> setUserLoginStatus(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(userLoginStatus, value);
  }

  static Future<bool> getUserLoginStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool value = pref.getBool(userLoginStatus) ?? false;
    return value;
  }

  static Future<void> setDocVerifyStatus(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(docVerifyStatus, value);
  }

  static Future<bool> getDocVerifyStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(docVerifyStatus) ?? false;
  }

  static Future<void> setOwnerLoginStatus(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(ownerLoginStatus, value);
  }

  static Future<bool> isOwnerLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(ownerLoginStatus) ?? false;
  }

  static Future<void> setDriverUserModel(DriverUserModel userModel) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Preferences.userModel = userModel;
    String jsonString = json.encode(userModel.toJson());
    driverModel = Driver.fromJson(userModel.toJson());
    await saveUserModelOnline(userModel);
    await pref.setString('driverUserModel', jsonString);
  }

  static Future<DriverUserModel?> getDriverUserModel() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? jsonString = pref.getString('driverUserModel');
    if (jsonString != null) {
      try {
        Preferences.userModel =
            DriverUserModel.fromJson(json.decode(jsonString));
        return userModel;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<void> openMapWithDirections({
    required double destinationLatitude,
    required double destinationLongitude,
    double startLatitude = 0,
    double startLongitude = 0,
  }) async {
    try {
      if (startLatitude == 0) {
        loc.LocationData? currentLocation = await loc.Location().getLocation();

        startLatitude = currentLocation.latitude!;
        startLongitude = currentLocation.longitude!;
      }

      final googleMapsUrl =
          'https://www.google.com/maps/dir/?api=1&origin=$startLatitude,$startLongitude&destination=$destinationLatitude,$destinationLongitude';
      final appleMapsUrl =
          'https://maps.apple.com/?saddr=$startLatitude,$startLongitude&daddr=$destinationLatitude,$destinationLongitude';

      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl); // Open in Google Maps
      } else if (await canLaunch(appleMapsUrl)) {
        await launch(appleMapsUrl); // Open in Apple Maps
      } else {
        throw 'Could not launch map.';
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
