import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:nia_app/src/model/lead_swap.dart';
import 'package:nia_app/src/model/profile.dart';
import 'package:nia_app/src/model/result.dart';
import 'package:nia_app/src/repo/groups_repo.dart';
import 'package:nia_app/src/repo/lead_swap_repo.dart';
import 'package:nia_app/src/repo/profile_repo.dart';
import 'package:nia_app/src/services/profile_service.dart';

import 'package:nia_app/src/util/secure_storage_util.dart';
import 'package:nia_app/src/util/shared_preferences_util.dart';

class LeadSwapService implements LeadSwapRepo {
  @override
  Future<LeadSwapResponse> sendLeasSwaps(
      String recipientName,
      String firstName,
      String lastName,
      String prospectPhoneNumber,
      String prospectEmailAddress,
      String estimatedValue,
      String notes,
      String status,
      String leadInstructions,
      String recipientId,
      String recipient) async {
    try {
      String url = "http://networkinaction.com:3000/lead_swap";

      var token = await SecureStorageUtil().retrieveAuthenticationToken();
      String userId = (await SharedPreferencesUtil().getUserId()).toString();

      Result<Profile> profileResult = await ProfileService()
          .getProfile(userId: int.parse(userId), token: token);

      ProfileRepo.instance.profile = profileResult.result;
      Profile profile = ProfileRepo.instance.profile;

      Uri uri = Uri.parse(url);

      Map<String, String> headers = {
        "Authorization": token,
        "Content-Type": "application/json"
      };

      Map<String, dynamic> body = {
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": prospectPhoneNumber,
        "email": prospectEmailAddress,
        "lead_instructions": leadInstructions,
        "opportunity_value": estimatedValue,
        "notes": notes,
        "recipient": recipient,
        "creator_id": userId,
        "creator_groups": GroupsRepo.instance.selectedGroup.id.toString(),
        "creator_name": profile.title,
        "creator_email": profile.email,
        "recipient_id": recipientId,
        "recipient_name": recipientName
      };

      final request = Request('POST', uri);
      request.body = jsonEncode(body);
      request.headers.addAll(headers);

      final response = await request.send();

      if (response.statusCode == 200) {
        LeadSwapResponse leadSwapResponseFromJson(String str) =>
            LeadSwapResponse.fromJson(json.decode(str));

        final respStr = await response.stream.bytesToString();

        final leadSwapResponse = leadSwapResponseFromJson(respStr);
        return leadSwapResponse;
      }
    } catch (e) {
      return e;
    }
  }
}
