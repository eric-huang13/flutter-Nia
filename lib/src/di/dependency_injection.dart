//check if prod or debug
//In the future we can do this in main.dart
//void main() async {
//  inject production api
//   Injector.configure(Flavor.PROD);
//  runApp(MyApp());
//}
import 'package:nia_app/src/repo/comment_post_repo.dart';
import 'package:nia_app/src/repo/lead_swap_repo.dart';
import 'package:nia_app/src/repo/likes_repo.dart';
import 'package:nia_app/src/repo/pavement_points_repo.dart';
import 'package:nia_app/src/repo/user_activity_repo.dart';
import 'package:nia_app/src/services/comment_post_service.dart';
import 'package:nia_app/src/services/lead_swap_points_service.dart';
import 'package:nia_app/src/services/like_post_service.dart';
import 'package:nia_app/src/services/pavement_points_service.dart';
import 'package:nia_app/src/services/user_activity_response_Service.dart';

enum Flavor { MOCK, PROD }

//DI
class Injector {
  static final Injector _singleton = new Injector._internal();
  static Flavor _flavor;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  UserActivityRepo get userActivityRepo {
    return new UserActivityService();
  }

  LikePostRepo get likePostRepo {
    return new LikePostService();
  }

  CommentPostRepo get commentPostRepo {
    return new CommentPostService();
  }

  PavementPointsRepo get pavementPointsRepo {
    return new PavementPointsService();
  }

  LeadSwapRepo get leadSwapRepo {
    return new LeadSwapService();
  }
}
