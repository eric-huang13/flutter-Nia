import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:nia_app/src/model/user_activity_response.dart';
import 'package:nia_app/src/repo/user_activity_repo.dart';
import 'package:nia_app/src/util/secure_storage_util.dart';

class UserActivityService implements UserActivityRepo {
  @override
  Future<List<Activity>> fetchUserActivity(groupId) async {
    String url = "http://networkinaction.com:3000/user_activity";

    var token = await SecureStorageUtil().retrieveAuthenticationToken();

    Uri uri = Uri.parse(url);

    Map<String, String> headers = {
      "Authorization": '${token}',
      "Content-Type": "application/json"
    };

    final request = Request('GET', uri);
    request.body = '{"groupid": $groupId}';
    request.headers.addAll(headers);
    final response = await request.send();
    print('${response.contentLength}');
    if (response.statusCode == 200) {
//      List<Activity> userActivityResponseFromJson(String str) =>
//          UserActivityResponse.fromJson(json.decode(str)).activities.activities;

      UserActivityResponse userActivityResponseFromJson(String str) =>
          UserActivityResponse.fromJson(json.decode(str));

      final respStr = await response.stream.bytesToString();
      print('${respStr}');
      final userActivityResponse = userActivityResponseFromJson(respStr);
      print('${userActivityResponse.activities.activities.activities.length}');
      return userActivityResponse.activities.activities.activities;
    }
  }
}
