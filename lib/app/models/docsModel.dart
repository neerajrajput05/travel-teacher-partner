import 'dart:convert';


class DocsModel {
  String id;
  String type;
  String name;
  String document_number;
  String date_of_birth;
  List<String> image;
  bool isVerify;

  DocsModel({
    required this.type,
    required this.document_number,
    required this.name,
    required this.date_of_birth,
    required this.id,
    required this.image,
    this.isVerify = true,
  });

  factory DocsModel.fromRawJson(String str) =>
      DocsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DocsModel.fromJson(Map<String, dynamic> json) => DocsModel(
        id: json["id"],
        type: json["documentType"],
        document_number: json["documentNumber"],
        name: "",
        date_of_birth: json["dateOfBirth"],
        isVerify: json["isVerified"] ?? true,
        image: List<String>.from(json["images"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "document_number": document_number,
        "name": name,
        "date_of_birth": date_of_birth,
        "isVerify": isVerify,
        "image": image,
      };
}
