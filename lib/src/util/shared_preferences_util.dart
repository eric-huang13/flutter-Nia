import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  final String _loginStatusKey = 'loginStatus';
  final String _userIdKey = 'userId';
  final String _firstTimeStatus = 'firstTimeStatus';

  SharedPreferences _sharedPreferences;

  Future<SharedPreferences> _getSharedPreferencesInstance() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }

    return _sharedPreferences;
  }

  Future<bool> isThisUsersFirstTime() async {
    SharedPreferences _sharedPreferences =
        await _getSharedPreferencesInstance();
    return _sharedPreferences.getBool(_firstTimeStatus) ?? true;
  }

  Future<bool> setUsersFirstTimeAsFalse() async {
    SharedPreferences _sharedPreferences =
        await _getSharedPreferencesInstance();
    return _sharedPreferences.setBool(_firstTimeStatus, false);
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences _sharedPreferences =
        await _getSharedPreferencesInstance();
    return _sharedPreferences.getBool(_loginStatusKey) ?? false;
  }

  Future<bool> setUserLogInStatus({@required bool loginStatus}) async {
    SharedPreferences _sharedPreferences =
        await _getSharedPreferencesInstance();

    return _sharedPreferences.setBool(_loginStatusKey, loginStatus);
  }

  Future<int> getUserId() async {
    SharedPreferences _sharedPreferences =
        await _getSharedPreferencesInstance();
    return _sharedPreferences.getInt(_userIdKey);
  }

  Future<bool> setUserId({@required int userId}) async {
    SharedPreferences _sharedPreferences =
        await _getSharedPreferencesInstance();
    return _sharedPreferences.setInt(_userIdKey, userId);
  }

  Future<void> removeUserId() async {
    SharedPreferences _sharedPreferences =
        await _getSharedPreferencesInstance();
    return _sharedPreferences.remove(_userIdKey);
  }
}
