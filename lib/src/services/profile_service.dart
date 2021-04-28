import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:nia_app/src/model/profile.dart';
import 'package:nia_app/src/model/result.dart';

class ProfileService {
  Future<Result<Profile>> getProfile(
      {@required int userId, @required String token}) async {
    try {
      String url = 'http://networkinaction.com:3000/user_profile';
      Uri uri = Uri.parse(url);

      Map<String, String> headers = {
        "Authorization": token,
        "Content-Type": "application/json"
      };

      final request = Request('GET', uri);
      request.body = '{"userid": "$userId"}';
      request.headers.addAll(headers);
      final response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map decodedResponseString = jsonDecode(responseString);

        if (decodedResponseString['error'] == false) {
          Profile profile = Profile.fromJson(decodedResponseString['profile']);
          return Result<Profile>(result: profile, message: null);
        } else {
          return Result<Profile>(
              result: null, message: 'Failed to get profile');
        }
      } else {
        throw Exception('Failed to get profile');
      }
    } catch (e) {
      return Result<Profile>(result: null, message: 'Failed to get profile');
    }
  }
}
