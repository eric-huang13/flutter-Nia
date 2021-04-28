import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:nia_app/src/model/login_response.dart';
import 'package:nia_app/src/model/result.dart';

class AuthService {
  Future<Result<LoginResponse>> login(
      {@required String username, @required String password}) async {
    try {
      String url = 'http://networkinaction.com:3000/login';
      http.Response response = await http.post(url,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: jsonEncode({'username': username, 'password': password}));

      if (response.statusCode == 200) {
        LoginResponse loginResponse = loginResponseFromJson(response.body);

        return Result<LoginResponse>(
            result: loginResponse, message: loginResponse.message);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      return Result<LoginResponse>(
          result: null, message: e.toString().replaceAll('Exception: ', ''));
    }
  }
}
