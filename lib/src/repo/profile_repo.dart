import 'package:nia_app/src/model/profile.dart';

class ProfileRepo {
  Profile profile;

  ProfileRepo._private();
  static final ProfileRepo instance = ProfileRepo._private();
}
