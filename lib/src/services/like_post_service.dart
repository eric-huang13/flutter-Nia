import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:nia_app/src/repo/likes_repo.dart';
import 'package:nia_app/src/util/secure_storage_util.dart';
import 'package:nia_app/src/util/shared_preferences_util.dart';

class LikePostService implements LikePostRepo {
  @override
  Future<bool> likePost({@required String likeId, @required String app}) async {
    try {
      String url = "http://networkinaction.com:3000/like_post";

      var token = await SecureStorageUtil().retrieveAuthenticationToken();
      String userId = (await SharedPreferencesUtil().getUserId()).toString();

      Uri uri = Uri.parse(url);

      Map<String, String> headers = {
        "Authorization": token,
        "Content-Type": "application/json"
      };

      Map<String, dynamic> body = {
        "user_id": userId,
        "like_id": likeId,
        "app": app
      };

      final request = Request('POST', uri); 
      request.body = jsonEncode(body);
      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        Map decodedResponseString = jsonDecode(responseString);

        if (decodedResponseString['success'] != null &&
            decodedResponseString['success'] == true) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
