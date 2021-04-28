import 'package:flutter/foundation.dart';
import 'package:nia_app/src/di/dependency_injection.dart';
import 'package:nia_app/src/model/post_user_activity_comment_response.dart';
import 'package:nia_app/src/repo/comment_post_repo.dart';

abstract class CommentPostViewContract {
  onCommentPostComplete(
      {@required
          PostUserActivityCommentResponse postUserActivityCommentResponse,
      @required
          int commentId,
      @required
          String comment});

  onCommentPostError();
}

class CommentPostViewPresenter {
  CommentPostViewContract _view;
  CommentPostRepo _repo;

  CommentPostViewPresenter(this._view) {
    _repo = new Injector().commentPostRepo;
  }

  postComment(int commentId, String app, String userComment) {
    _repo
        .postUserActivityComment(commentId, app, userComment)
        .then((postUserActivityCommentResponse) => _view.onCommentPostComplete(
              postUserActivityCommentResponse: postUserActivityCommentResponse,
              commentId: commentId,
              comment: userComment,
            ))
        .catchError((onError) => _view.onCommentPostError());
  }
}
