import 'package:nia_app/src/model/user_activity_response.dart';

abstract class UserActivityRepo {
  Future<List<Activity>> fetchUserActivity(String groupId);

}

class FetchDataException implements Exception {
  final message;

  FetchDataException([this.message]);

  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}
