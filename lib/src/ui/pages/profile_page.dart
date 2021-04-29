import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/model/profile.dart';
import 'package:nia_app/src/model/result.dart';
import 'package:nia_app/src/repo/profile_repo.dart';
import 'package:nia_app/src/services/profile_service.dart';
import 'package:nia_app/src/ui/pages/earn_pavement_points.dart';
import 'package:nia_app/src/ui/spacers.dart';
import 'package:nia_app/src/ui/widgets/optional_buttons.dart';
import 'package:nia_app/src/util/modified_vcard.dart';
import 'package:nia_app/src/util/secure_storage_util.dart';
import 'package:nia_app/src/util/shared_preferences_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../util/extensions_util.dart';

class ProfilePage extends StatefulWidget {
  final bool isSelfProfile;
  final int memberId;

  const ProfilePage({Key key, this.isSelfProfile = true, this.memberId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double appBarElevation = 0.0;
  bool _isLoading = false;
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _getProfile();
    _refreshController.refreshCompleted();
  }

  Future<String> get _localPath async {
    final dir = await getExternalStorageDirectory();

    return dir.path;
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/contact.vcf');
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  _getProfile() async {
    if (ProfileRepo.instance.profile == null) {
      setState(() {
        _isLoading = true;
      });
      int userId = widget.isSelfProfile == false ? widget.memberId : await SharedPreferencesUtil().getUserId();
      String token = await SecureStorageUtil().retrieveAuthenticationToken();

      Result<Profile> profileResult = await ProfileService().getProfile(userId: userId, token: token);

      setState(() {
        _isLoading = false;
        ProfileRepo.instance.profile = profileResult.result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Profile profile = ProfileRepo.instance.profile;

    Container getCompleteProfile(Profile profile) {
      return Container(
        margin: EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(profile.avatar),
                  radius: 50.0,
                ),
                AppSpacers.mediumVerticalSpacer,
                Text(profile.name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                AppSpacers.extraSmallVerticalSpacer,
                Text('${profile.state} - ${profile.city}'),
                AppSpacers.mediumVerticalSpacer,
                Container(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(color: AppColors.white)),
                          child: Material(
                            color: AppColors.transparent,
                            child: InkWell(
                              splashColor: AppColors.white.withOpacity(0.7),
                              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                              onTap: () async {
                                final PermissionHandler _permissionHandler = PermissionHandler();
                                var result = await _permissionHandler.requestPermissions([PermissionGroup.storage]);
                                print("thando $result");
                                if (result[PermissionGroup.storage] == PermissionStatus.granted) {
                                  ///Create a new vCard
                                  var vCard = VCard();

                                  ///Set properties
                                  vCard.firstName = profile.title;
                                  vCard.middleName = "";
                                  vCard.lastName = profile.title;
                                  vCard.organization = profile.company;
                                  vCard.photo
                                      .attachFromUrl('http://networkinaction.com/images/avatar/group/de7090fb016655c5bba345d9.png', 'PNG');
                                  vCard.workPhone = profile.phoneNumber;
                                  vCard.cellPhone = profile.mobilePhoneNumber;
                                  vCard.title = profile.title;
                                  vCard.url = profile.website;
                                  vCard.note = profile.aboutMe;
                                  vCard.email = profile.email;
                                  vCard.homeAddress.label = 'Home Address';
                                  vCard.homeAddress.street = profile.address;
                                  vCard.homeAddress.city = profile.city;
                                  vCard.homeAddress.stateProvince = profile.state;
                                  vCard.homeAddress.postalCode = profile.zip;
                                  vCard.homeAddress.countryRegion = profile.country;
                                  vCard.socialUrls['Yelp Reference URL'] = profile.yelpReferenceUrl;
                                  vCard.socialUrls['Google Reference URL'] = profile.googleReferenceUrl;
                                  vCard.socialUrls['Facebook Reference URL'] = profile.facebookReferenceUrl;

                                  final file = await _localFile;

                                  if (file.existsSync()) {
                                    print('file exists');
                                  } else {
                                    print('file does not exist');
                                  }

                                  /// Save to file
                                  vCard.writeVcard();

                                  final path = await _localPath;

                                  getTemporaryDirectory().then((tempDir) {
                                    File('$path/contact.vcf').copySync("${tempDir.path}/contacts.vcf");
                                    final MailOptions mailOptions = MailOptions(
                                      body: 'BODY',
                                      subject: 'SUBJECT',
                                      recipients: ['example@example.com'],
                                      isHTML: true,
                                      attachments: [
                                        "${tempDir.path}/contacts.vcf",
                                      ],
                                    );
                                    FlutterMailer.send(mailOptions).then((v) {
                                      // TODO: Delete the temp file
                                    }).catchError((errE) {
                                      print(errE);
                                    });
                                  });

                                  /// Get as formatted string
                                  print(vCard.getFormattedString());
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 18),
                                child: Center(
                                  child: Text(
                                    AppStrings.sendContactInfo,
                                    textAlign: TextAlign.left,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 0.27, color: AppColors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      AppSpacers.mediumHorizontalSpacer,
                      new Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.lightGrey.withOpacity(0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(color: AppColors.white)),
                          child: Material(
                            color: AppColors.transparent,
                            child: InkWell(
                              splashColor: AppColors.white.withOpacity(0.7),
                              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EarnPavementPointsPage()),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 18),
                                child: Center(
                                  child: Text(
                                    AppStrings.earnPavementPoints,
                                    textAlign: TextAlign.left,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600, fontSize: 12, letterSpacing: 0.27, color: AppColors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacers.extraLargeVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.phoneNumber,
                  details: profile.phoneNumber,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.perfectReferralDescription,
                  details: profile.perfectReferralDescription,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.aboutMe,
                  details: profile.aboutMe,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.company,
                  details: profile.company,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.profession,
                  details: profile.profession,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.title,
                  details: profile.title,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.hobbies,
                  details: profile.hobbies,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.specialOffers,
                  details: profile.specialOffers,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.address,
                  details: profile.address,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.city,
                  details: profile.city,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.state,
                  details: profile.state,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.zip,
                  details: profile.zip,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.country,
                  details: profile.country,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.website,
                  details: profile.website,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.college,
                  details: profile.college,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.gradYear,
                  details: profile.gradYear,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.email,
                  details: profile.email,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.whatIsYourWhy,
                  details: profile.whatIsYourWhy,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.qualifyingQuestions,
                  details: profile.qualifyingQuestions,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.birthdate,
                  details: profile.birthdate,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.mobilePhoneNumber,
                  details: profile.mobilePhoneNumber,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.yelpReferenceUrl,
                  details: profile.yelpReferenceUrl,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.googleReferenceUrl,
                  details: profile.googleReferenceUrl,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.facebookReferenceUrl,
                  details: profile.facebookReferenceUrl,
                ),
                AppSpacers.mediumVerticalSpacer,
                ProfilePageDetailsItem(
                  title: AppStrings.howWouldYouLikeToBeIntroduced,
                  details: profile.howWouldYouLikeToBeIntroduced,
                ),
                AppSpacers.mediumVerticalSpacer,
              ],
            ),
          ),
        ),
      );
    }

    Widget getBody() {
      if (_isLoading) {
        return Center(child: CircularProgressIndicator());
      } else {
        if (profile == null) {
          return Center(child: Text('Could not get profile'));
        } else {
          return getCompleteProfile(profile);
        }
      }
    }

    return Scaffold(
      appBar: widget.isSelfProfile == false
          ? AppBar(
              elevation: appBarElevation,
              backgroundColor: AppColors.transparent,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: AppColors.primaryColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(AppStrings.profilePageTitle, style: TextStyle(color: AppColors.primaryColor)),
              centerTitle: true,
            )
          : null,

      //Show an app bar if it's not the profile of the account owner (self)
      // Else show no app bar so the page can use the one that comes from
      // the main page
      body: getBody(),
    );
  }
}

class ProfilePageDetailsItem extends StatelessWidget {
  const ProfilePageDetailsItem({
    Key key,
    @required this.title,
    @required this.details,
  }) : super(key: key);

  final String title;
  final String details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AutoSizeText(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        AppSpacers.extraSmallVerticalSpacer,
        AutoSizeText(
          details.isNullOrEmpty() ? AppStrings.notAvailable : details,
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
