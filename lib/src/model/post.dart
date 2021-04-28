import 'package:flutter/foundation.dart';

class Post {
  final String name;
  final String timeAgo;
  final String numberOfLikes;
  final String numberOfComments;
  final String postText;

  Post({
    @required this.name,
    @required this.timeAgo,
    @required this.numberOfLikes,
    @required this.numberOfComments,
    @required this.postText,
  });
}
