

import 'package:nia_app/src/model/pavement_points_response.dart';

abstract class PavementPointsRepo {
  Future<PavementPointsResponse> sendPavementPoints(String meetingType,String dateOfMeeting,String userFullName,String hostEmail);

}

class FetchDataException implements Exception {
  final message;

  FetchDataException([this.message]);

  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}
