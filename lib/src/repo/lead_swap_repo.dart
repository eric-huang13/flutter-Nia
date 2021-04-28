import 'package:nia_app/src/model/lead_swap.dart';

abstract class LeadSwapRepo {
  Future<LeadSwapResponse> sendLeasSwaps(String recipientName, String firstName, String lastName, String prospectPhoneNumber,String prospectEmailAddress, String estimatedValue, String notes, String status, String leadInstructions, String recipientIdController, String recipient);

}

class FetchDataException implements Exception {
  final message;

  FetchDataException([this.message]);

  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}
