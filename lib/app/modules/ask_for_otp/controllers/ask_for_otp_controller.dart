// ignore_for_file: unnecessary_overrides
import 'dart:developer';
import 'dart:typed_data';

import 'package:driver/app/models/booking_model.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/constant/booking_status.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class AskForOtpController extends GetxController {
  GoogleMapController? mapController;

  @override
  void onInit() {
    // TODO: implement onInit
    getLocation();
    addMarkerSetup();
    getArgument();
    // playSound();
    super.onInit();
  }

  Rx<DriverUserModel> driverUserModel = DriverUserModel().obs;
  Rx<BookingModel> bookingModel = BookingModel().obs;

  RxBool isLoading = true.obs;
  RxString type = "".obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      // bookingModel.value = argumentData['bookingModel'];

      getPolyline(
          sourceLatitude:
              Preferences.rideModule!.pickupLocation.coordinates?[0] ?? 0,
          sourceLongitude:
              Preferences.rideModule!.dropoffLocation.coordinates?[1] ?? 0,
          destinationLatitude:
              Preferences.rideModule!.dropoffLocation.coordinates?[0] ?? 0,
          destinationLongitude:
              Preferences.rideModule!.dropoffLocation.coordinates?[1] ?? 0);

      if (Preferences.rideModule!.status == BookingStatus.bookingCompleted) {
        Get.back();
      }
    }
    isLoading.value = false;
    update();
  }

  BitmapDescriptor? departureIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? driverIcon;

  void getPolyline(
      {required double? sourceLatitude,
      required double? sourceLongitude,
      required double? destinationLatitude,
      required double? destinationLongitude}) async {
    try {
      if (sourceLatitude != null &&
          sourceLongitude != null &&
          destinationLatitude != null &&
          destinationLongitude != null) {
        List<LatLng> polylineCoordinates = [];
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleApiKey: Constant.mapAPIKey,
          request: PolylineRequest(
            origin: PointLatLng(sourceLatitude, sourceLongitude),
            destination: PointLatLng(destinationLatitude, destinationLongitude),
            mode: TravelMode.driving,
            alternatives:
                true, // Enable alternative routes to increase the chances of getting a route
          ),
        );

        if (result.status == "OK") {
          if (result.points.isNotEmpty) {
            for (var point in result.points) {
              polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            }
          } else {
            log("No points found in the route.");
          }
        } else if (result.status == "ZERO_RESULTS") {
          log("Unable to get route: Response ---> ZERO_RESULTS");
        } else {
          log(result.errorMessage.toString());
        }

        addMarker(
            latitude:
                Preferences.rideModule!.pickupLocation.coordinates?[0] ?? 0,
            longitude:
                Preferences.rideModule!.pickupLocation.coordinates?[1] ?? 0,
            id: "Departure",
            descriptor: departureIcon!,
            rotation: 0.0);
        addMarker(
            latitude:
                Preferences.rideModule!.dropoffLocation.coordinates?[0] ?? 0,
            longitude:
                Preferences.rideModule!.dropoffLocation.coordinates?[1] ?? 0,
            id: "Destination",
            descriptor: destinationIcon!,
            rotation: 0.0);
        addMarker(
            latitude: Preferences.driverLat,
            longitude: Preferences.driverLong,
            id: "Driver",
            descriptor: driverIcon!,
            rotation: driverUserModel.value.rotation);

        _addPolyLine(polylineCoordinates);
      }
    } catch (e) {
      e.printError();
    }
  }

  double lat = 0, long = 0;

  void getLocation() async {
    loc.Location location = loc.Location();
    loc.LocationData data = await location.getLocation();
    lat = data.latitude!;
    long = data.longitude!;
  }

  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  addMarker(
      {required double? latitude,
      required double? longitude,
      required String id,
      required BitmapDescriptor descriptor,
      required double? rotation}) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        icon: descriptor,
        position: LatLng(latitude ?? 0.0, longitude ?? 0.0),
        rotation: rotation ?? 0.0);
    markers[markerId] = marker;
  }

  addMarkerSetup() async {
    final Uint8List departure = await Constant()
        .getBytesFromAsset('assets/icon/ic_pick_up_map.png', 100);
    final Uint8List destination = await Constant()
        .getBytesFromAsset('assets/icon/ic_drop_in_map.png', 100);
    final Uint8List driver =
        await Constant().getBytesFromAsset('assets/icon/ic_car.png', 50);
    departureIcon = BitmapDescriptor.fromBytes(departure);
    destinationIcon = BitmapDescriptor.fromBytes(destination);
    driverIcon = BitmapDescriptor.fromBytes(driver);
  }

  RxMap<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{}.obs;
  PolylinePoints polylinePoints = PolylinePoints();

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        points: polylineCoordinates,
        consumeTapEvents: true,
        startCap: Cap.roundCap,
        width: 6,
        color: Colors.blue);
    polyLines[id] = polyline;
    updateCameraLocation(
        polylineCoordinates.first, polylineCoordinates.last, mapController);
  }

  Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
    GoogleMapController? mapController,
  ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 10);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(
      CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }
}
