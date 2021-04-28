import 'package:flutter/foundation.dart';

abstract class LikePostRepo {
  Future<bool> likePost({@required String likeId, @required String app});
}
