import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/model/profile.dart';
import 'package:nia_app/src/model/result.dart';
import 'package:nia_app/src/repo/profile_repo.dart';
import 'package:nia_app/src/services/profile_service.dart';
import 'package:nia_app/src/ui/pages/create_a_connection_page.dart';
import 'package:nia_app/src/ui/pages/earn_pavement_points.dart';
import 'package:nia_app/src/ui/pages/pass_a_referral_page.dart';
import 'package:nia_app/src/ui/pages/post_an_update_page.dart';
import 'package:nia_app/src/ui/pages/schedule_one_on_one_page.dart';
import 'package:nia_app/src/ui/spacers.dart';
import 'package:nia_app/src/ui/widgets/action_Button_Icon.dart';
import 'package:nia_app/src/util/modified_vcard.dart';
import 'package:nia_app/src/util/secure_storage_util.dart';
import 'package:nia_app/src/util/shared_preferences_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ActionButtonPage extends StatefulWidget {
  @override
  _ActionButtonPageState createState() => _ActionButtonPageState();
}

class _ActionButtonPageState extends State<ActionButtonPage> {
  bool _isLoading = false;
  final TextStyle actionButtonPageTextStyle = TextStyle(
    fontSize: 17,
    color: AppColors.semiLightGrey,
    fontWeight: FontWeight.w400,
  );

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

  _getProfile() async {
    if (ProfileRepo.instance.profile == null) {
      setState(() {
        _isLoading = true;
      });
      int userId = await SharedPreferencesUtil().getUserId();
      String token = await SecureStorageUtil().retrieveAuthenticationToken();

      Result<Profile> profileResult =
          await ProfileService().getProfile(userId: userId, token: token);

      setState(() {
        _isLoading = false;
        ProfileRepo.instance.profile = profileResult.result;
      });

      return;
    }
    return;
  }

  _getProfileAndSendContactInfo() async {
    await _getProfile();

    Profile profile = ProfileRepo.instance.profile;

    if (profile != null) {
      final PermissionHandler _permissionHandler = PermissionHandler();
      var result = await _permissionHandler
          .requestPermissions([PermissionGroup.storage]);

      if (result[PermissionGroup.storage] == PermissionStatus.granted) {
        ///Create a new vCard
        var vCard = VCard();

        ///Set properties
        vCard.firstName = profile.title;
        vCard.middleName = "";
        vCard.lastName = profile.title;
        vCard.organization = profile.company;
        vCard.photo.attachFromUrl(
            'http://networkinaction.com/images/avatar/group/de7090fb016655c5bba345d9.png',
            'PNG');
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
        vCard.socialUrls['Facebook Reference URL'] =
            profile.facebookReferenceUrl;

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
    } else {
      _showSnackbar(message: 'Could not fetch profile. Try again');
    }
  }

  _showSnackbar({@required message}) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.lightSilverGrey,
        ),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AppSpacers.extraLargeVerticalSpacer,
                  AppSpacers.extraLargeVerticalSpacer,
                  AppSpacers.extraLargeVerticalSpacer,
                  AppSpacers.extraLargeVerticalSpacer,
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          _buildActionButton(
                              text: AppStrings.sendContactInfo,
                              context: context,
                              onTap: () {
                                _getProfileAndSendContactInfo();
                              }),
                          ActionButtonIcon(icon: Icons.call),
                        ],
                      ),
                      AppSpacers.largeVerticalSpacer,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          _buildActionButton(
                            text: AppStrings.postAnUpdate,
                            context: context,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostAnUpdatePage()),
                              );
                            },
                          ),
                          ActionButtonIcon(icon: Icons.message),
                        ],
                      ),
                      AppSpacers.largeVerticalSpacer,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          _buildActionButton(
                              text: AppStrings.createAConnection,
                              context: context,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreateAConnectionPage()),
                                );
                              }),
                          ActionButtonIcon(icon: Icons.autorenew),
                        ],
                      ),
                      AppSpacers.largeVerticalSpacer,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          _buildActionButton(
                              text: AppStrings.earnPavementPoints,
                              context: context,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EarnPavementPointsPage()),
                                );
                              }),
                          ActionButtonIcon(icon: Icons.poll),
                        ],
                      ),
                      AppSpacers.largeVerticalSpacer,
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.end,
//                        children: <Widget>[
//                          _buildActionButton(
//                              text: AppStrings.scheduleAOneOnOne,
//                              context: context,
//                              onTap: () {
//                                Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) =>
//                                          ScheduleOneOnOnePage()),
//                                );
//                              }),
//                          ActionButtonIcon(icon: Icons.people),
//                        ],
//                      ),
                      //  AppSpacers.largeVerticalSpacer,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          _buildActionButton(
                              text: AppStrings.passAReferral,
                              context: context,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PassAReferralPage()),
                                );
                              }),
                          ActionButtonIcon(icon: Icons.compare_arrows),
                        ],
                      ),
                    ],
                  ),
                  AppSpacers.extraLargeVerticalSpacer,
                  AppSpacers.extraLargeVerticalSpacer,
                  AppSpacers.extraLargeVerticalSpacer,
                ],
              ),
            ),
            Align(
              alignment: Alignment(0.9, 0.8),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: AppColors.lightRed,
                child: Icon(Feather.x),
              ),
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                        AppColors.lightRed,
                      ),
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    @required String text,
    @required BuildContext context,
    @required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryElement,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            text,
            textAlign: TextAlign.right,
            style: actionButtonPageTextStyle,
          ),
        ),
      ),
    );
  }
}
