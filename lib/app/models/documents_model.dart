import 'dart:convert';

class DocumentsModel {
  final String id;
  final String title;
  final String slug;
  final String term;
  final String type;
  final String image;
  final String status;
  final int side;
  final int createdAt;
  final int? updatedAt;

  DocumentsModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.term,
    required this.type,
    required this.image,
    required this.status,
    required this.side,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DocumentsModel.fromRawJson(String str) =>
      DocumentsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DocumentsModel.fromJson(Map<String, dynamic> json) => DocumentsModel(
        id: json["_id"],
        title: json["name"],
        slug: json["slug"],
        term: json["term"],
        type: json["type"],
        image: json["image"],
        status: json["status"],
        side: json["side"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  factory DocumentsModel.empty() => DocumentsModel(
        id: "",
        title: "",
        slug: "",
        term: "",
        type: "",
        image: "",
        status: "",
        side: 1,
        createdAt: 0,
        updatedAt: 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": title,
        "slug": slug,
        "term": term,
        "type": type,
        "image": image,
        "status": status,
        "side": side,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
