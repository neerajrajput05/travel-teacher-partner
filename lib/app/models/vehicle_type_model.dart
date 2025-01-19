import 'dart:convert';

class VehicleTypeModel {
  final String id;
  final String image;
  final String activeStatus;
  final String name;
  final String slug;

  VehicleTypeModel({
    required this.id,
    required this.image,
    required this.activeStatus,
    required this.name,
    required this.slug,
  });

  factory VehicleTypeModel.fromRawJson(String str) =>
      VehicleTypeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) =>
      VehicleTypeModel(
        id: json["_id"],
        image: json["image"],
        activeStatus: json["status"],
        name: json["name"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "status": activeStatus,
        "name": name,
        "slug": slug,
      };
}

class Charges {
  final String fareMinimumChargesWithinKm;
  final String farMinimumCharges;
  final String farePerKm;

  Charges({
    required this.fareMinimumChargesWithinKm,
    required this.farMinimumCharges,
    required this.farePerKm,
  });

  factory Charges.fromRawJson(String str) => Charges.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Charges.fromJson(Map<String, dynamic> json) => Charges(
        fareMinimumChargesWithinKm: json["fare_minimum_charges_within_km"],
        farMinimumCharges: json["far_minimum_charges"],
        farePerKm: json["fare_per_km"],
      );

  Map<String, dynamic> toJson() => {
        "fare_minimum_charges_within_km": fareMinimumChargesWithinKm,
        "far_minimum_charges": farMinimumCharges,
        "fare_per_km": farePerKm,
      };
}
