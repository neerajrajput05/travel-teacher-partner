
class MyDriverModel {
  String? id; // Corresponds to _id
  Location? location; // Corresponds to location
  String? name; // Corresponds to name
  String? email; // Corresponds to email
  String? password; // Corresponds to password
  String? countryCode; // Corresponds to country_code
  String? phone; // Corresponds to phone
  String? referralCode; // Corresponds to referral_code
  String? referralCodeBy; // Corresponds to referral_code_by
  bool? verified; // Corresponds to verified
  String? otpForgetPassword; // Corresponds to otpForgetPassword
  String? role; // Corresponds to role
  String? rideStatus; // Corresponds to ride_status
  String? ownerId; // Corresponds to owner_id
  List<String>? languages; // Corresponds to languages
  String? gender; // Corresponds to gender
  DateTime? dateOfBirth; // Corresponds to date_of_birth
  String? profile; // Corresponds to profile
  String? token; // Corresponds to token
  String? pushNotification; // Corresponds to push_notification
  String? status; // Corresponds to status
  String? suspend; // Corresponds to suspend
  int? yearOfExperience; // Corresponds to year_of_experience
  String? education; // Corresponds to education
  DateTime? createdAt; // Corresponds to createdAt
  DateTime? updatedAt; // Corresponds to updatedAt
  int? version; // Corresponds to __v

  MyDriverModel({
    this.id,
    this.location,
    this.name,
    this.email,
    this.password,
    this.countryCode,
    this.phone,
    this.referralCode,
    this.referralCodeBy,
    this.verified,
    this.otpForgetPassword,
    this.role,
    this.rideStatus,
    this.ownerId,
    this.languages,
    this.gender,
    this.dateOfBirth,
    this.profile,
    this.token,
    this.pushNotification,
    this.status,
    this.suspend,
    this.yearOfExperience,
    this.education,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory MyDriverModel.fromJson(Map<String, dynamic> json) => MyDriverModel(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        countryCode: json["country_code"],
        phone: json["phone"],
        referralCode: json["referral_code"],
        referralCodeBy: json["referral_code_by"],
        verified: json["verified"],
        otpForgetPassword: json["otpForgetPassword"],
        role: json["role"],
        rideStatus: json["ride_status"],
        ownerId: json["owner_id"],
        languages: List<String>.from(json["languages"].map((x) => x)),
        gender: json["gender"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        profile: json["profile"],
        token: json["token"],
        pushNotification: json["push_notification"],
        status: json["status"],
        suspend: json["suspend"],
        yearOfExperience: json["year_of_experience"],
        education: json["education"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json["createdAt"]),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(json["updatedAt"]),
        location: json["location"] != null
            ? Location.fromJson(json["location"])
            : null,
        version: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "location": location?.toJson(),
        "name": name,
        "email": email,
        "password": password,
        "country_code": countryCode,
        "phone": phone,
        "referral_code": referralCode,
        "referral_code_by": referralCodeBy,
        "verified": verified,
        "otpForgetPassword": otpForgetPassword,
        "role": role,
        "ride_status": rideStatus,
        "owner_id": ownerId,
        "languages": languages,
        "gender": gender,
        "date_of_birth": dateOfBirth?.toIso8601String(),
        "profile": profile,
        "token": token,
        "push_notification": pushNotification,
        "status": status,
        "suspend": suspend,
        "year_of_experience": yearOfExperience,
        "education": education,
        "createdAt": createdAt?.millisecondsSinceEpoch,
        "updatedAt": updatedAt?.millisecondsSinceEpoch,
        "__v": version,
      };
}

class Location {
  String? type; // Corresponds to type
  List<double>? coordinates; // Corresponds to coordinates

  Location({this.type, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates,
      };
}
