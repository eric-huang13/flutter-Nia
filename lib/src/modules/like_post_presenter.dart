import 'package:flutter/foundation.dart';
import 'package:nia_app/src/di/dependency_injection.dart';
import 'package:nia_app/src/repo/likes_repo.dart';

abstract class LikePostContract {
  void onLikePostComplete({@required bool status, @required String likeId});
  void onLikePostError();
  void onUnlikePostComplete({@required bool status, @required String likeId});
  void onUnlikePostError();
}

class LikePostPresenter {
  LikePostContract _view;
  LikePostRepo _repo;

  LikePostPresenter(this._view) {
    _repo = new Injector().likePostRepo;
  }

  void likePost({@required String likeId, @required String app}) {
    _repo
        .likePost(likeId: likeId, app: app)
        .then((status) =>
            _view.onLikePostComplete(status: status, likeId: likeId))
        .catchError((onError) => _view.onLikePostError());
  }

  void unlikePost({@required String likeId, @required String app}) {
    _repo
        .likePost(likeId: likeId, app: app)
        .then((status) =>
            _view.onUnlikePostComplete(status: status, likeId: likeId))
        .catchError((onError) => _view.onUnlikePostError());
  }
}
