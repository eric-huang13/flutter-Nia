import 'dart:convert';

class SearchUsersResponse {
  bool error;
  Results results;

  SearchUsersResponse({
    this.error,
    this.results,
  });

  factory SearchUsersResponse.fromJson(Map<String, dynamic> json) => SearchUsersResponse(
    error: json["error"],
    results: Results.fromJson(json["results"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "results": results.toJson(),
  };
}

class Results {
  List<User> users;

  Results({
    this.users,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}

class User {
  int userid;
  String name;

  User({
    this.userid,
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userid: json["userid"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "userid": userid,
    "name": name,
  };
}