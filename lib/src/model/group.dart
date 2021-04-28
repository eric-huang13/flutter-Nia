// To parse this JSON data, do
//
//     final group = groupFromJson(jsonString);

import 'package:meta/meta.dart';

List<Group> groupListFromJson(List listOfMaps) =>
    List<Group>.from(listOfMaps.map((x) => Group.fromJson(x))).toSet().toList();

class Group {
  final int id;
  final String name;
  final String avatar;
  final String thumb;
  final String cover;
  final int ownerid;
  final String ownername;

  Group({
    @required this.id,
    @required this.name,
    @required this.avatar,
    @required this.thumb,
    @required this.cover,
    @required this.ownerid,
    @required this.ownername,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["id"],
        name: json["name"],
        avatar: json["avatar"],
        thumb: json["thumb"],
        cover: json["cover"],
        ownerid: json["ownerid"],
        ownername: json["ownername"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "avatar": avatar,
        "thumb": thumb,
        "cover": cover,
        "ownerid": ownerid,
        "ownername": ownername,
      };

  bool operator ==(Object other) =>
      identical(this, other) || (other as Group).id == id;
  int get hashCode => id.hashCode;
}
