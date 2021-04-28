import 'package:flutter/foundation.dart';

class NotificationModel {
  final String username;
  final String actionString;
  final String time;

  NotificationModel({
    @required this.username,
    @required this.actionString,
    @required this.time,
  });
}
