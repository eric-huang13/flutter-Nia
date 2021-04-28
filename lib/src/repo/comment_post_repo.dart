
import 'package:nia_app/src/model/post_user_activity_comment_response.dart';

abstract class CommentPostRepo {
  Future<PostUserActivityCommentResponse> postUserActivityComment(int commentId, String app,  String userComment);
}