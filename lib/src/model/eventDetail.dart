import 'package:flutter/foundation.dart';

class EventDetail {
  final String eventName;
  final String location;
  final String month;
  final String day;
  final String dateAndTime;
  final String description;

  EventDetail({
    @required this.eventName,
    @required this.location,
    @required this.month,
    @required this.day,
    @required this.dateAndTime,
    @required this.description,
  });
}