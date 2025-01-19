
class BookingModel {
  String? id; // Corresponds to _id
  String? rideId; // Corresponds to ride_id
  String? driverId; // Corresponds to driver_id
  String? notes; // Corresponds to notes
  String? status; // Corresponds to status
  String? createdAt; // Corresponds to createdAt
  String? updatedAt; // Corresponds to updatedAt
  int? version; // Corresponds to __v
  Ride? ride; // Corresponds to ride
  Passenger? passengers; // Corresponds to passenger
  Driver? drivers; // Corresponds to driver
  String? dropTime; // Corresponds to dropTime
  List<String>? rejectedDriverId; // Add this line
  String? cancelledBy; // Add this line

  BookingModel({
    this.id,
    this.rideId,
    this.driverId,
    this.notes,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.version,
    this.ride,
    this.passengers,
    this.drivers,
    this.dropTime,
    this.rejectedDriverId,
    this.cancelledBy,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id: json["_id"],
        rideId: json["ride"]['_id'],
        driverId: json["driver_id"],
        notes: json["notes"],
        status: json["status"],
        createdAt: json["createdAt"].toString(),
        updatedAt: json["updatedAt"].toString(),
        version: 0,
        ride: json["ride"] != null ? Ride.fromJson(json["ride"]) : null,
        passengers: (json["passenger"] != null)
            ? Passenger.fromJson(json["passenger"])
            : Passenger.fromJson(json["user"]),
        drivers:
            (json['driver'] == null) ? null : Driver.fromJson(json['driver']),
        dropTime: json["dropTime"],
        rejectedDriverId: json['rejectedDriverId'] ?? [], // Add this line
        cancelledBy: json["cancelledBy"], // Add this line
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "ride_id": rideId,
        "driver_id": driverId,
        "notes": notes,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": version,
        "ride": ride?.toJson(),
        "passenger": passengers,
        "driver": drivers,
        "dropTime": dropTime,
        "rejectedDriverId": rejectedDriverId, // Add this line
        "cancelledBy": cancelledBy, // Add this line
      };
}

class Ride {
  String? id; // Corresponds to _id
  String? passengerId; // Corresponds to passenger_id
  String? driverId; // Corresponds to driver_id
  String? vehicleId; // Corresponds to vehicle_id
  String? vehicleTypeId; // Corresponds to vehicle_type_id
  Location? pickupLocation; // Corresponds to pickup_location
  String? pickupAddress; // Corresponds to pickup_address
  Location? dropoffLocation; // Corresponds to dropoff_location
  String? dropoffAddress; // Corresponds to dropoff_address
  String? distance; // Corresponds to distance
  String? fareAmount; // Corresponds to fare_amount
  String? durationInMinutes; // Corresponds to duration_in_minutes
  String? rideStatus; // Corresponds to status
  String? couponId; // Corresponds to coupon_id
  String? otp; // Corresponds to otp
  String? paymentStatus; // Corresponds to payment_status
  String? paymentMode; // Corresponds to payment_mode
  String? createdAt; // Corresponds to createdAt
  String? updatedAt; // Corresponds to updatedAt
  int? version; // Corresponds to __v

  Ride({
    this.id,
    this.passengerId,
    this.driverId,
    this.vehicleId,
    this.vehicleTypeId,
    this.pickupLocation,
    this.pickupAddress,
    this.dropoffLocation,
    this.dropoffAddress,
    this.distance,
    this.fareAmount,
    this.durationInMinutes,
    this.rideStatus,
    this.couponId,
    this.otp,
    this.paymentStatus,
    this.paymentMode,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory Ride.fromJson(Map<String, dynamic> json) => Ride(
      id: json["_id"],
      passengerId: json["passenger_id"],
      driverId: json["driver_id"],
      vehicleId: json["vehicle_id"],
      vehicleTypeId: json["vehicle_type_id"],
      pickupLocation: json["pickup_location"] != null
          ? Location.fromJson(json["pickup_location"])
          : null,
      pickupAddress: json["pickup_address"],
      dropoffLocation: json["dropoff_location"] != null
          ? Location.fromJson(json["dropoff_location"])
          : null,
      dropoffAddress: json["dropoff_address"],
      distance: json["distance"],
      fareAmount: json["fare_amount"],
      durationInMinutes: json["duration_in_minutes"],
      rideStatus: json["status"],
      couponId: json["coupon_id"],
      otp: json["otp"],
      paymentStatus: json["payment_status"],
      paymentMode: json["payment_mode"],
      createdAt: json["createdAt"].toString(),
      updatedAt: json["updatedAt"].toString(),
      version: 0);

  get startTime => null;

  Map<String, dynamic> toJson() => {
        "_id": id,
        "passenger_id": passengerId,
        "driver_id": driverId,
        "vehicle_id": vehicleId,
        "vehicle_type_id": vehicleTypeId,
        "pickup_location": pickupLocation?.toJson(),
        "pickup_address": pickupAddress,
        "dropoff_location": dropoffLocation?.toJson(),
        "dropoff_address": dropoffAddress,
        "distance": distance,
        "fare_amount": {"\$numberDecimal": fareAmount},
        "duration_in_minutes": durationInMinutes,
        "status": rideStatus,
        "coupon_id": couponId,
        "otp": otp,
        "payment_status": paymentStatus,
        "payment_mode": paymentMode,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": version,
      };
}

class Location {
  String? type; // Corresponds to type
  List<double>? coordinates; // Corresponds to coordinates

  Location({this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates: (json["coordinates"] == null)
            ? null
            : List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates,
      };
}

class Passenger {
  String? id; // Corresponds to _id
  String? name; // Corresponds to name
  String? countryCode; // Corresponds to country_code
  String? phone; // Corresponds to phone
  bool? verified; // Corresponds to verified
  String? referralCode; // Corresponds to referral_code
  String? referralCodeBy; // Corresponds to referral_code_by
  String? role; // Corresponds to role
  String? rideStatus; // Corresponds to ride_status
  String? languages; // Corresponds to languages
  Location? location; // Corresponds to location
  String? createdAt; // Corresponds to createdAt
  String? updatedAt; // Corresponds to updatedAt
  String? gender; // Corresponds to gender

  Passenger({
    this.id,
    this.name,
    this.countryCode,
    this.phone,
    this.verified,
    this.referralCode,
    this.referralCodeBy,
    this.role,
    this.rideStatus,
    this.languages,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.gender,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
        id: json["_id"],
        name: json["name"] ?? '',
        countryCode: json["country_code"],
        phone: json["phone"],
        verified: json["verified"],
        referralCode: json["referral_code"],
        referralCodeBy: json["referral_code_by"],
        role: json["role"],
        rideStatus: json["ride_status"],
        languages: json["languages"] ?? '',
        location: json["location"] != null
            ? Location.fromJson(json["location"])
            : null,
        createdAt: json["createdAt"].toString(),
        updatedAt: json["updatedAt"].toString(),
        gender: json["gender"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "country_code": countryCode,
        "phone": phone,
        "verified": verified,
        "referral_code": referralCode,
        "referral_code_by": referralCodeBy,
        "role": role,
        "ride_status": rideStatus,
        "languages": languages,
        "location": location?.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "gender": gender,
      };
}

class Driver {
  String? id; // Corresponds to _id
  String? name; // Corresponds to name
  String? countryCode; // Corresponds to country_code
  String? phone; // Corresponds to phone
  bool? verified; // Corresponds to verified
  String? referralCode; // Corresponds to referral_code
  String? referralCodeBy; // Corresponds to referral_code_by
  String? role; // Corresponds to role
  String? rideStatus; // Corresponds to ride_status
  List<String>? languages; // Corresponds to languages
  Location? location; // Corresponds to location
  String? createdAt; // Corresponds to createdAt
  String? updatedAt; // Corresponds to updatedAt
  String? gender; // Corresponds to gender

  Driver({
    this.id,
    this.name,
    this.countryCode,
    this.phone,
    this.verified,
    this.referralCode,
    this.referralCodeBy,
    this.role,
    this.rideStatus,
    this.languages,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.gender,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json["_id"],
        name: json["name"],
        countryCode: json["country_code"],
        phone: json["phone"],
        verified: json["verified"],
        referralCode: json["referral_code"],
        referralCodeBy: json["referral_code_by"],
        role: json["role"],
        rideStatus: json["ride_status"],
        languages: null,
        location: json["location"] != null
            ? Location.fromJson(json["location"])
            : null,
        createdAt: json["createdAt"].toString(),
        updatedAt: json["updatedAt"].toString(),
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "country_code": countryCode,
        "phone": phone,
        "verified": verified,
        "referral_code": referralCode,
        "referral_code_by": referralCodeBy,
        "role": role,
        "ride_status": rideStatus,
        "languages": languages,
        "location": location?.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "gender": gender,
      };
}

class RideResponse {
  final bool status;
  final String msg;
  final List<RideData> data;

  RideResponse({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory RideResponse.fromJson(Map<String, dynamic> json) {
    return RideResponse(
      status: json['status'],
      msg: json['msg'],
      data: List<RideData>.from(json['data'].map((x) => RideData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class RideData {
  final String id;
  final String passengerId;
  final String driverId;
  final String vehicleId;
  final String vehicleTypeId;
  final Location pickupLocation;
  final String pickupAddress;
  final Location dropoffLocation;
  final String dropoffAddress;
  final String distance;
  final String fareAmount;
  final String durationInMinutes;
  final String status;
  final String? couponId;
  final String otp;
  final String? paymentStatus;
  final String paymentMode;
  final DateTime startTime;
  final DateTime? endTime;
  final int createdAt;
  final int updatedAt;
  final User user;

  RideData({
    required this.id,
    required this.passengerId,
    required this.driverId,
    required this.vehicleId,
    required this.vehicleTypeId,
    required this.pickupLocation,
    required this.pickupAddress,
    required this.dropoffLocation,
    required this.dropoffAddress,
    required this.distance,
    required this.fareAmount,
    required this.durationInMinutes,
    required this.status,
    this.couponId,
    required this.otp,
    this.paymentStatus,
    required this.paymentMode,
    required this.startTime,
    this.endTime,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory RideData.fromJson(Map<String, dynamic> json) {
    return RideData(
      id: json['ride']['_id'],
      passengerId: json['passenger']['_id'],
      driverId: json['driver']['_id'],
      vehicleId: json['vehicle']['name'],
      vehicleTypeId: json['vehicle']['name'],
      pickupLocation: Location.fromJson(json['ride']['pickup_location']),
      pickupAddress: json['ride']['pickup_address'],
      dropoffLocation: Location.fromJson(json['ride']['dropoff_location']),
      dropoffAddress: json['ride']['dropoff_address'],
      distance: json['ride']['distance'],
      fareAmount: json['ride']['fare_amount'],
      durationInMinutes: json['ride']['duration_in_minutes'],
      status: json['status'],
      couponId: json['ride']['coupon_id'],
      otp: json['ride']['otp'],
      paymentStatus: json['ride']['payment_status'],
      paymentMode: json['ride']['payment_mode'],
      startTime: DateTime.parse(json['ride']['start_time']),
      endTime: json['ride']['end_time'] != null
          ? DateTime.parse(json['ride']['end_time'])
          : null,
      createdAt: json['ride']['createdAt'],
      updatedAt: 0,
      user: User.fromJson(json['passenger']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'passenger_id': passengerId,
      'driver_id': driverId,
      'vehicle_id': vehicleId,
      'vehicle_type_id': vehicleTypeId,
      'pickup_location': pickupLocation.toJson(),
      'pickup_address': pickupAddress,
      'dropoff_location': dropoffLocation.toJson(),
      'dropoff_address': dropoffAddress,
      'distance': distance,
      'duration_in_minutes': durationInMinutes,
      'status': status,
      'coupon_id': couponId,
      'otp': otp,
      'payment_status': paymentStatus,
      'payment_mode': paymentMode,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'user': user.toJson(),
    };
  }
}

class FareAmount {
  final String numberDecimal;

  FareAmount({required this.numberDecimal});

  factory FareAmount.fromJson(Map<String, dynamic> json) {
    return FareAmount(
      numberDecimal: json['\$numberDecimal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '\$numberDecimal': numberDecimal,
    };
  }
}

class User {
  final String id;
  final String name;
  final String countryCode;
  final String phone;
  final String referralCode;
  final String referralCodeBy;
  final bool verified;
  final String otp;
  final String otpForgetPassword;
  final String role;
  final String rideStatus;
  final String? ownerId;
  final String languages;
  final Location location;
  final String profile;
  final String token;
  final String pushNotification;
  final String status;
  final String suspend;
  final int yearOfExperience;
  final String education;
  final int createdAt;
  final int updatedAt;
  final String gender;

  User({
    required this.id,
    required this.name,
    required this.countryCode,
    required this.phone,
    required this.referralCode,
    required this.referralCodeBy,
    required this.verified,
    required this.otp,
    required this.otpForgetPassword,
    required this.role,
    required this.rideStatus,
    this.ownerId,
    required this.languages,
    required this.location,
    required this.profile,
    required this.token,
    required this.pushNotification,
    required this.status,
    required this.suspend,
    required this.yearOfExperience,
    required this.education,
    required this.createdAt,
    required this.updatedAt,
    required this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'] ?? '',
      countryCode: json['country_code'] ?? '',
      phone: json['phone'] ?? '',
      referralCode: json['referral_code'] ?? '',
      referralCodeBy: json['referral_code_by'] ?? '',
      verified: json['verified'] ?? true,
      otp: json['otp'] ?? '',
      otpForgetPassword: '',
      role: json['role'] ?? '',
      rideStatus: json['status'] ?? '',
      ownerId: json['owner_id'] ?? '',
      languages: '',
      profile: json['profile'] ?? '',
      token: json['token'] ?? '',
      pushNotification: json['push_notification'] ?? '',
      status: json['status'] ?? '',
      suspend: json['suspend'] ?? '',
      yearOfExperience: json['year_of_experience'] ?? 0,
      education: json['education'] ?? '',
      createdAt: json['createdAt'] ?? 0,
      updatedAt: json['updatedAt'] ?? 0,
      gender: json['gender'] ?? '',
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'country_code': countryCode,
      'phone': phone,
      'referral_code': referralCode,
      'referral_code_by': referralCodeBy,
      'verified': verified,
      'otp': otp,
      'otpForgetPassword': otpForgetPassword,
      'role': role,
      'ride_status': rideStatus,
      'owner_id': ownerId,
      'languages': languages,
      'location': location.toJson(),
      'profile': profile,
      'token': token,
      'push_notification': pushNotification,
      'status': status,
      'suspend': suspend,
      'year_of_experience': yearOfExperience,
      'education': education,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'gender': gender,
    };
  }
}
