import 'dart:convert';

import 'package:http/http.dart';
import 'package:nia_app/src/model/post_user_activity_comment_response.dart';
import 'package:nia_app/src/repo/comment_post_repo.dart';
import 'package:nia_app/src/util/secure_storage_util.dart';
import 'package:nia_app/src/util/shared_preferences_util.dart';

class CommentPostService implements CommentPostRepo {
  @override
  Future<PostUserActivityCommentResponse> postUserActivityComment(
      int commentId, String app, String userComment) async {
    String url = "http://networkinaction.com:3000/comment_post";

    var token = await SecureStorageUtil().retrieveAuthenticationToken();
    String userId = (await SharedPreferencesUtil().getUserId()).toString();

    Uri uri = Uri.parse(url);

    Map<String, String> headers = {
      "Authorization": token,
      "Content-Type": "application/json"
    };

    Map<String, dynamic> body = {
      "user_id": userId,
      "comment_id": commentId,
      "app": app,
      "comment": userComment
    };

    final request = Request('POST', uri);
    request.body = jsonEncode(body);
    request.headers.addAll(headers);

    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      PostUserActivityCommentResponse postUserActivityCommentResponseFromJson(
              String str) =>
          PostUserActivityCommentResponse.fromJson(json.decode(str));

      final postUserActivityCommentResponse =
          postUserActivityCommentResponseFromJson(respStr);

      return postUserActivityCommentResponse;
    }
  }
}
