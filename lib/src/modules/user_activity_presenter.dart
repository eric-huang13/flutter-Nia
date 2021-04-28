import 'package:nia_app/src/di/dependency_injection.dart';
import 'package:nia_app/src/model/user_activity_response.dart';
import 'package:nia_app/src/repo/user_activity_repo.dart';

abstract class UserActivityViewContract {
  void onLoadUserActivityComplete(List<Activity> items);

  void onLoadUserActivityError();
}

class UserActivityViewPresenter {
  UserActivityViewContract _view;
  UserActivityRepo _repo;

  UserActivityViewPresenter(this._view) {
    _repo = new Injector().userActivityRepo;
  }

  void loadUserActivity(String groupId) {
    _repo
        .fetchUserActivity(groupId)
        .then((c) => _view.onLoadUserActivityComplete(c))
        .catchError((onError) => _view.onLoadUserActivityError());
  }

  
}
