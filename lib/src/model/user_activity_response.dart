import 'package:flutter/foundation.dart';

//// To parse this JSON data, do
////
////     final userActivityResponse = userActivityResponseFromJson(jsonString);
////     UserActivityResponse userActivityResponseFromJson(String str) => UserActivityResponse.fromJson(json.decode(str));
////
////     String userActivityResponseToJson(UserActivityResponse data) => json.encode(data.toJson());
//
//import 'package:flutter/foundation.dart';
//
//class UserActivityResponse {
//  bool error;
//  Activities activities;
//
//  UserActivityResponse({
//    @required this.error,
//    @required this.activities,
//  });
//
//  factory UserActivityResponse.fromJson(Map<String, dynamic> json) =>
//      UserActivityResponse(
//        error: json["error"],
//        activities: Activities.fromJson(json["activities"]),
//      );
//
//  Map<String, dynamic> toJson() => {
//        "error": error,
//        "activities": activities.toJson(),
//      };
//}
//
//class Activities {
//  List<Activity> activities;
//
//  Activities({
//    this.activities,
//  });
//
//  factory Activities.fromJson(Map<String, dynamic> json) => Activities(
//      activities: List<Activity>.from(
//              json["activities"].map((x) => Activity.fromJson(x)))
//          .toSet()
//          .toList());
//
//  Map<String, dynamic> toJson() => {
//        "activities": List<dynamic>.from(activities.map((x) => x.toJson())),
//      };
//}
//
//class Activity {
//  int id;
//  String title;
//  String content;
//  int actor;
//  String app;
//  int eventid;
//  DateTime created;
//  DateTime updatedAt;
//  int likeId;
//  int commentId;
//  int likeCount;
//  List likesList;
//  int commentCount;
//  List<Comment> comments;
//
//  Activity({
//    @required this.id,
//    @required this.title,
//    @required this.content,
//    @required this.actor,
//    @required this.app,
//    @required this.eventid,
//    @required this.created,
//    @required this.updatedAt,
//    @required this.likeId,
//    @required this.commentId,
//    @required this.likeCount,
//    @required this.likesList,
//    @required this.commentCount,
//    @required this.comments,
//  });
//
//  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
//        id: json["id"],
//        title: json["title"],
//        content: json["content"],
//        actor: json["actor"],
//        app: json["app"],
//        eventid: json["eventid"],
//        created: DateTime.parse(json["created"]),
//        updatedAt: DateTime.parse(json["updated_at"]),
//        likeId: json["like_id"],
//        commentId: json["comment_id"],
//        likeCount: json["like_count"],
//        likesList: json["likes"],
//        commentCount: json["comment_count"],
//        comments: List<Comment>.from(
//            json["comments"].map((x) => Comment.fromJson(x))),
//      );
//
//  Map<String, dynamic> toJson() => {
//        "id": id,
//        "title": title,
//        "content": content,
//        "actor": actor,
//        "app": app,
//        "eventid": eventid,
//        "created": created.toIso8601String(),
//        "updated_at": updatedAt.toIso8601String(),
//        "like_id": likeId,
//        "comment_id": commentId,
//        "like_count": likeCount,
//        "likes": List<dynamic>.from(likesList.map((x) => x)),
//        "comment_count": commentCount,
//        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
//      };
//
//  bool operator ==(Object other) =>
//      identical(this, other) || (other as Activity).actor == actor;
//
//  int get hashCode => actor.hashCode;
//}
//
//class Comment {
//  String comment;
//  int postBy;
//
//  Comment({
//    this.comment,
//    this.postBy,
//  });
//
//  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
//        comment: json["comment"],
//        postBy: json["post_by"],
//      );
//
//  Map<String, dynamic> toJson() => {
//        "comment": comment,
//        "post_by": postBy,
//      };
//}

class UserActivityResponse {
  bool error;
  UserActivityResponseActivities activities;

  UserActivityResponse({
    this.error,
    this.activities,
  });

  factory UserActivityResponse.fromJson(Map<String, dynamic> json) =>
      UserActivityResponse(
        error: json["error"],
        activities: UserActivityResponseActivities.fromJson(json["activities"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "activities": activities.toJson(),
      };
}

class UserActivityResponseActivities {
  ActivitiesActivities activities;

  UserActivityResponseActivities({
    this.activities,
  });

  factory UserActivityResponseActivities.fromJson(Map<String, dynamic> json) =>
      UserActivityResponseActivities(
        activities: ActivitiesActivities.fromJson(json["activities"]),
      );

  Map<String, dynamic> toJson() => {
        "activities": activities.toJson(),
      };
}

class ActivitiesActivities {
  List<Activity> activities;

  ActivitiesActivities({
    this.activities,
  });

  factory ActivitiesActivities.fromJson(Map<String, dynamic> json) =>
      ActivitiesActivities(
        activities: List<Activity>.from(
            json["activities"].map((x) => Activity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "activities": List<dynamic>.from(activities.map((x) => x.toJson())),
      };
}

class Activity {
  int id;
  String title;
  String content;
  int actor;
  String app;
  int eventid;
  DateTime created;
  DateTime updatedAt;
  int likeId;
  int commentId;
  int likeCount;
  List likesList;
  int commentCount;
  List<Comment> comments;
  String name;
  String avatar;

  Activity(
      {@required this.id,
      @required this.title,
      @required this.content,
      @required this.actor,
      @required this.app,
      @required this.eventid,
      @required this.created,
      @required this.updatedAt,
      @required this.likeId,
      @required this.commentId,
      @required this.likeCount,
      @required this.likesList,
      @required this.commentCount,
      @required this.comments,
      @required this.name,
      @required this.avatar});

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      actor: json["actor"],
      app: json["app"],
      eventid: json["eventid"],
      created: DateTime.parse(json["created"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      likeId: json["like_id"],
      commentId: json["comment_id"],
      likeCount: json["like_count"] == null ? 0 : json["like_count"],
      likesList: json["likes"] == null
          ? []
          : List<String>.from(json["likes"].map((x) => x)),
      commentCount: json["comment_count"] == null ? 0 : json["comment_count"],
      comments: json["comments"] == null
          ? []
          : List<Comment>.from(
              json["comments"].map((x) => Comment.fromJson(x))),
      name: json["name"],
      avatar: json["avatar"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "actor": actor,
        "app": app,
        "eventid": eventid,
        "created": created.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "like_id": likeId,
        "comment_id": commentId,
        "like_count": likeCount == null ? 0 : likeCount,
        "likes": likesList == null
            ? []
            : List<dynamic>.from(likesList.map((x) => x)),
        "comment_count": commentCount == null ? 0 : commentCount,
        "comments": comments == null
            ? []
            : List<dynamic>.from(comments.map((x) => x.toJson())),
        "name": name,
        "avatar": avatar,
      };

  bool operator ==(Object other) =>
      identical(this, other) || (other as Activity).actor == actor;

  int get hashCode => actor.hashCode;
}

class Comment {
  String comment;
  int postBy;
  String avatar;
  String name;

  Comment({
    this.comment,
    this.postBy,
    this.avatar,
    this.name,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        comment: json["comment"],
        postBy: json["post_by"],
        avatar: json["avatar"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "post_by": postBy,
        "avatar": avatar,
        "name": name,
      };
}
