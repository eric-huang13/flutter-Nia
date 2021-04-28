import 'package:nia_app/src/di/dependency_injection.dart';
import 'package:nia_app/src/model/lead_swap.dart';
import 'package:nia_app/src/repo/lead_swap_repo.dart';

abstract class LeadSwapViewContract {
  onLoadLeadSwapComplete(LeadSwapResponse swapLeadResult) {}

  onLoadLeadSwapError() {}
}

class LeadSwapViewPresenter {
  LeadSwapViewContract _view;
  LeadSwapRepo _repo;

  LeadSwapViewPresenter(this._view) {
    _repo = new Injector().leadSwapRepo;
  }

  void postLeadSwap(
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
      String recipient) {
    _repo
        .sendLeasSwaps(
            recipientName,
            firstName,
            lastName,
            prospectPhoneNumber,
            prospectEmailAddress,
            estimatedValue,
            notes,
            status,
            leadInstructions,
            recipientId,
            recipient)
        .then((c) => _view.onLoadLeadSwapComplete(c))
        .catchError((onError) => _view.onLoadLeadSwapError());
  }
}
