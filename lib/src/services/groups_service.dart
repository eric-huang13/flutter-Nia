import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:nia_app/src/model/group.dart';
import 'package:nia_app/src/model/result.dart';

class GroupService {
  Future<Result<List<Group>>> getGroups(
      {@required int userId, @required String token}) async {
    try {
      String url = "http://networkinaction.com:3000/groups";

      Uri uri = Uri.parse(url);

      Map<String, String> headers = {
        "Authorization": token,
        "Content-Type": "application/json"
      };

      final request = Request('GET', uri);

      request.body = jsonEncode({"userid": userId.toString()});
      request.headers.addAll(headers);
      final response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();

        Map decodedResponseMap = jsonDecode(responseString);

        if (decodedResponseMap['error'] == false) {
          var data = decodedResponseMap['data'];
          var groupMapList = data['groups'];

          List<Group> listOfGroups = groupListFromJson(groupMapList);

          return Result<List<Group>>(
              result: listOfGroups, message: decodedResponseMap['message']);
        } else {
          return Result<List<Group>>(
              result: null, message: 'Failed to get groups');
        }
      } else {
        throw Exception('Failed to get groups');
      }
    } catch (e) {
      return Result<List<Group>>(result: null, message: 'Failed to get groups');
    }
  }
}
