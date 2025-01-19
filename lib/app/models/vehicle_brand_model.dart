import 'dart:convert';

class VehicleBrandModel {
  final String id;
  final String name;
  final String slug;
  final String term;
  final String type;
  final String status;
  final List<VehicleModel> models;

  VehicleBrandModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.term,
    required this.type,
    required this.status,
    required this.models,
  });

  factory VehicleBrandModel.fromRawJson(String str) => VehicleBrandModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VehicleBrandModel.fromJson(Map<String, dynamic> json) => VehicleBrandModel(
    id: json["_id"],
    name: json["name"],
    slug: json["slug"],
    term: json["term"],
    type: json["type"],
    status: json["status"],
    models: List<VehicleModel>.from(json["models"].map((x) => VehicleModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "slug": slug,
    "term": term,
    "type": type,
    "status": status,
    "models": List<dynamic>.from(models.map((x) => x.toJson())),
  };

  factory VehicleBrandModel.empty() => VehicleBrandModel(
    id: '',
    name: '',
    slug: '',
    term: '',
    type: '',
    status: '',
    models: [], // Empty list for models
  );
}

class VehicleModel {
  final String id;
  final String name;
  final String slug;
  final String term;
  final String type;
  final String parent;
  final String image;
  final String status;
  final ChargeModel charges;
  final int? persons;
  final int createdAt;
  final int updatedAt;

  VehicleModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.term,
    required this.type,
    required this.parent,
    required this.image,
    required this.status,
    required this.charges,
    this.persons,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
    id: json["_id"],
    name: json["name"],
    slug: json["slug"],
    term: json["term"],
    type: json["type"],
    parent: json["parent"],
    image: json["image"],
    status: json["status"],
    charges: ChargeModel.fromJson(json["charges"]),
    persons: json["persons"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "slug": slug,
    "term": term,
    "type": type,
    "parent": parent,
    "image": image,
    "status": status,
    "charges": charges.toJson(),
    "persons": persons,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };

  factory VehicleModel.empty() => VehicleModel(
    id: '',
    name: '',
    slug: '',
    term: '',
    type: '',
    parent: '',
    image: '',
    status: '',
    charges: ChargeModel(), // Assuming ChargeModel has a default constructor
    persons: null,
    createdAt: 0,
    updatedAt: 0,
  );
}

class ChargeModel {
  final dynamic farePerKm;
  final dynamic fareMinimumChargesWithinKm;
  final dynamic fareMinimumCharges;

  ChargeModel({
    this.farePerKm,
    this.fareMinimumChargesWithinKm,
    this.fareMinimumCharges,
  });

  factory ChargeModel.fromJson(Map<String, dynamic> json) => ChargeModel(
    farePerKm: json["fare_per_km"],
    fareMinimumChargesWithinKm: json["fare_minimum_charges_within_km"],
    fareMinimumCharges: json["fare_minimum_charges"],
  );

  Map<String, dynamic> toJson() => {
    "fare_per_km": farePerKm,
    "fare_minimum_charges_within_km": fareMinimumChargesWithinKm,
    "fare_minimum_charges": fareMinimumCharges,
  };
}
