import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyDriverModel {
  Timestamp? createAt;
  String? driverEmail;
  String? driverId;
  String? driverName;
  List<dynamic>? verifyDocument;

  VerifyDriverModel({
    this.createAt,
    this.driverEmail,
    this.driverId,
    this.driverName,  
    this.verifyDocument,
  });



}

class VerifyDocument {
  String? documentId;
  String? name;
  String? number;
  String? dob;
  List<dynamic> documentImage;
  bool? isVerify;

  VerifyDocument({
    this.documentId,
    this.name,
    this.number,
    this.dob,
    required this.documentImage,
    this.isVerify,
  });

  factory VerifyDocument.fromRawJson(String str) =>
      VerifyDocument.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyDocument.fromJson(Map<String, dynamic> json) => VerifyDocument(
        documentId: json["documentId"],
        name: json["name"],
        number: json["number"],
        dob: json["dob"],
        documentImage: json["documentImage"] ?? [],
        isVerify: json["isVerify"],
      );

  Map<String, dynamic> toJson() => {
        "documentId": documentId,
        "name": name,
        "number": number,
        "dob": dob,
        "documentImage": documentImage ?? [],
        "isVerify": isVerify,
      };
}
