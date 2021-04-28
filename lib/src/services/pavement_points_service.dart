import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:nia_app/src/model/pavement_points_response.dart';
import 'package:nia_app/src/repo/pavement_points_repo.dart';

import 'package:nia_app/src/util/secure_storage_util.dart';
import 'package:nia_app/src/util/shared_preferences_util.dart';

class PavementPointsService implements PavementPointsRepo {
  @override
  Future<PavementPointsResponse> sendPavementPoints(String meetingType,
      String dateOfMeeting, String userFullName, String hostEmail) async {
    try {
      String url = "http://networkinaction.com:3000/pavement_points";

      var token = await SecureStorageUtil().retrieveAuthenticationToken();
      String userId = (await SharedPreferencesUtil().getUserId()).toString();

      Uri uri = Uri.parse(url);

      Map<String, String> headers = {
        "Authorization": token,
        "Content-Type": "application/json"
      };

      Map<String, dynamic> body = {
        "userid": userId,
        "meeting_type": meetingType,
        "date_of_meeting": dateOfMeeting,
        "user_full_name": userFullName,
        "host_email": hostEmail
      };

      final request = Request('POST', uri);
      request.body = jsonEncode(body);
      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200) {
        PavementPointsResponse pavementPointsResponseFromJson(String str) =>
            PavementPointsResponse.fromJson(json.decode(str));

        final respStr = await response.stream.bytesToString();

        final pavementPointsResponse = pavementPointsResponseFromJson(respStr);
        return pavementPointsResponse;
      }
    } catch (e) {
      return e;
    }
  }
}
