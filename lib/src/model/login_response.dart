// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  final bool error;
  final Data data;
  final String message;

  LoginResponse({
    @required this.error,
    @required this.data,
    @required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        error: json["error"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  final String token;
  final int userid;

  Data({
    @required this.token,
    @required this.userid,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        userid: json["userid"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "userid": userid,
      };
}
