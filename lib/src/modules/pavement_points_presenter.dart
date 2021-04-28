import 'package:nia_app/src/di/dependency_injection.dart';
import 'package:nia_app/src/model/pavement_points_response.dart';
import 'package:nia_app/src/repo/pavement_points_repo.dart';

abstract class PavementPointsViewContract {
  void onLoadPavementPointsError();

  onLoadPavementPointsComplete(PavementPointsResponse c) {}
}

class PavementPointsViewPresenter {
  PavementPointsViewContract _view;
  PavementPointsRepo _repo;

  PavementPointsViewPresenter(this._view) {
    _repo = new Injector().pavementPointsRepo;
  }

  void postPavementPoints(String meetingType, String dateOfMeeting,
      String userFullName, String hostEmail) {
    _repo
        .sendPavementPoints(meetingType, dateOfMeeting, userFullName, hostEmail)
        .then((c) => _view.onLoadPavementPointsComplete(c))
        .catchError((onError) => _view.onLoadPavementPointsError());
  }
}
