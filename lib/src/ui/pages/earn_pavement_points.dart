import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/model/pavement_points_response.dart';
import 'package:nia_app/src/model/profile.dart';
import 'package:nia_app/src/model/result.dart';
import 'package:nia_app/src/model/search_users_Response.dart';
import 'package:nia_app/src/modules/pavement_points_presenter.dart';
import 'package:nia_app/src/repo/profile_repo.dart';
import 'package:nia_app/src/services/profile_service.dart';
import 'package:nia_app/src/ui/spacers.dart';
import 'package:nia_app/src/ui/widgets/round_slider_track_shape.dart';
import 'package:nia_app/src/ui/widgets/wide_button.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:nia_app/src/util/secure_storage_util.dart';
import 'package:nia_app/src/util/shared_preferences_util.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

TextEditingController _textEditingControllerOneToOneEmail =
    TextEditingController();
String meetingType;

String dateOfMeeting;

class EarnPavementPointsPage extends StatefulWidget {
  @override
  _EarnPavementPointsPageState createState() => _EarnPavementPointsPageState();
}

class _EarnPavementPointsPageState extends State<EarnPavementPointsPage>
    implements PavementPointsViewContract {
  int height = 180;
  List<String> whatTypeOfMeetingDidYouAttend = [
    "MonthlyMeeting w/ Guest(s) - 60 Points!",
    "Coaching Session - 30 Points!",
    "One-to-one - 25 Points!",
    "Tag-along - 35 Points!",
    'Mini Meet - 20 Points!',
    'Monthly Meeting - 10 Points!',
    'Virtual Meeting (Webinar or Facetime) - 15 Points!'
  ];
  final format = DateFormat("yyyy-MM-dd HH:mm");
  PavementPointsViewPresenter _presenter;
  bool _isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  bool isLoading = false;

  _getProfile() async {
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
  }

  _EarnPavementPointsPageState() {
    _presenter = new PavementPointsViewPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    Profile profile = ProfileRepo.instance.profile;
    return Scaffold(
          key: _scaffoldkey,
          appBar: AppBar(
            title: Text(AppStrings.earnPavementPoints),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.check),
              )
            ],
          ),
          body: _isLoading == true
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage:
                                  CachedNetworkImageProvider(profile.avatar),
                              radius: 50.0,
                            ),
                            AppSpacers.mediumVerticalSpacer,
                            // Text(profile.title,
                            //     style: TextStyle(
                            //         fontSize: 20.0,
                            //         fontWeight: FontWeight.bold)),
                            // AppSpacers.extraSmallVerticalSpacer,
                            // Text('Rank'),
                            // AppSpacers.extraSmallVerticalSpacer,
                            // Text('Points'),
                            // AppSpacers.extraSmallVerticalSpacer,
                            // SliderTheme(
                            //   data: SliderTheme.of(context).copyWith(
                            //       trackHeight: 9,
                            //       activeTrackColor: AppColors.primaryColor,
                            //       inactiveTrackColor:
                            //           AppColors.primaryColorLight,
                            //       thumbColor: AppColors.primaryColor,
                            //       overlayColor: AppColors.white,
                            //       trackShape: RoundSliderTrackShape(radius: 8),
                            //       overlayShape: RoundSliderOverlayShape(
                            //           overlayRadius: 30.0),
                            //       rangeTrackShape:
                            //           RoundedRectRangeSliderTrackShape()),
                            //   child: Slider(
                            //     value: height.toDouble(),
                            //     min: 120.0,
                            //     max: 310.0,
                            //     onChanged: (double newValue) {
                            //       setState(() {
                            //         height = newValue.round();
                            //       });
                            //     },
                            //   ),
                            // ),
                            // Row(
                            //   children: <Widget>[
                            //     Text(
                            //       AppStrings.pointsTillNextRank,
                            //       style: TextStyle(
                            //           color: AppColors.primaryColor
                            //               .withOpacity(0.7)),
                            //     ),
                            //     Spacer(),
                            //     Text(AppStrings.nextRank,
                            //         style: TextStyle(
                            //             color: AppColors.primaryColor
                            //                 .withOpacity(0.7))),
                            //   ],
                            // ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 14.0, top: 14.0),
                              child: Text(
                                AppStrings.whatTypeOfMeetingDidYouAttend,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ),
                            RadioButtonGroup(
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12.0),
                              labels: [
                                AutoSizeText(
                                  whatTypeOfMeetingDidYouAttend[0],
                                  maxLines: 1,
                                ).data,
                                AutoSizeText(whatTypeOfMeetingDidYouAttend[1],
                                        maxLines: 1)
                                    .data,
                                AutoSizeText(whatTypeOfMeetingDidYouAttend[2],
                                        maxLines: 1)
                                    .data,
                                AutoSizeText(whatTypeOfMeetingDidYouAttend[3],
                                        maxLines: 1)
                                    .data,
                                AutoSizeText(whatTypeOfMeetingDidYouAttend[4],
                                        maxLines: 1)
                                    .data,
                                AutoSizeText(whatTypeOfMeetingDidYouAttend[5],
                                        maxLines: 1)
                                    .data,
                                AutoSizeText(whatTypeOfMeetingDidYouAttend[6],
                                        maxLines: 1)
                                    .data,
                              ],
                              onChange: (String label, int index) => {
                                if (index == 0) {meetingType = "60"},
                                if (index == 1) {meetingType = "30"},
                                if (index == 2)
                                  {
                                    Alert(
                                        context: context,
                                        title: "Who did you meet with",
                                        content: SizedBox(
                                          height: 500,
                                          width: 500,
                                          child:
                                              new SearchEarnPavementPointsUsers(),
                                        ),
                                        buttons: []).show(),
                                    meetingType = "25"
                                  },
                                if (index == 3) {meetingType = "35"},
                                if (index == 4) {meetingType = "20"},
                                if (index == 5) {meetingType = "10"},
                                if (index == 6) {meetingType = "15"}
                              },
                              onSelected: (String label) =>
                                  (String label, int index) {
                                print(index);
                              },
                            ),
                            AppSpacers.mediumVerticalSpacer,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  AppStrings.oneToOneRecipient,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                AppSpacers.extraSmallVerticalSpacer,
                                TextFormField(
                                  enabled: false,
                                  controller:
                                      _textEditingControllerOneToOneEmail,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                  decoration: InputDecoration(
                                    //labelText: AppStrings.oneToOneRecipient,

                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.primaryColor,
                                            width: 0.0)),
                                  ),
                                ),
                              ],
                            ),
                            AppSpacers.mediumVerticalSpacer,
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: DateTimeField(
                                    decoration: InputDecoration(
                                      labelText: AppStrings.whenWasTheMeeting,
                                      suffixIcon: Icon(
                                          FontAwesome5Regular.calendar_alt),
                                    ),
                                    format: format,
                                    onShowPicker:
                                        (context, currentValue) async {
                                      final date = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1900),
                                          initialDate:
                                              currentValue ?? DateTime.now(),
                                          lastDate: DateTime(2100));
                                      if (date != null) {
                                        final time = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.fromDateTime(
                                              currentValue ?? DateTime.now()),
                                        );
                                        dateOfMeeting =
                                            DateTimeField.combine(date, time)
                                                .toString();

                                        return DateTimeField.combine(
                                            date, time);
                                      } else {
                                        return currentValue;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            AppSpacers.largeVerticalSpacer,
                            isLoading == false
                                ? WideButton(
                                    title: AppStrings.submitPoints,
                                    onTap: () {
                                      String hostEmail =
                                          _textEditingControllerOneToOneEmail
                                              .text;
                                      String userFullName = profile.title;
                                      _presenter.postPavementPoints(
                                          meetingType,
                                          dateOfMeeting,
                                          userFullName,
                                          hostEmail);

                                      setState(() {
                                        isLoading = true;
                                      });
                                      //   Navigator.pop(context);
                                    },
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        );
  }

  @override
  void onLoadPavementPointsError() {}

  void showSnackBar(String message) {
    final snackBarContent = SnackBar(
      content: Text(message),
      action: SnackBarAction(
          label: 'HIDE',
          onPressed: _scaffoldkey.currentState.hideCurrentSnackBar),
    );
    _scaffoldkey.currentState.showSnackBar(snackBarContent);
  }

  @override
  onLoadPavementPointsComplete(PavementPointsResponse postResult) {
    setState(() {
      isLoading = false;
    });

    if (postResult.success == true) {
      showSnackBar(AppStrings.submitted);
      print("Yes");
    } else {
      print("No");
      showSnackBar(AppStrings.notSubmitted);
    }
  }
}

class SearchEarnPavementPointsUsers extends StatefulWidget {
  @override
  _SearchEarnPavementPointsUsersState createState() =>
      _SearchEarnPavementPointsUsersState();
}

class _SearchEarnPavementPointsUsersState
    extends State<SearchEarnPavementPointsUsers> {
  final SearchBarController<User> _searchBarController = SearchBarController();
  bool isReplay = false;

  Future<List<User>> fetchSearchUser(userName) async {
    String url = "http://networkinaction.com:3000/nia_members";
    var token = await SecureStorageUtil().retrieveAuthenticationToken();

    Uri uri = Uri.parse(url);

    Map<String, String> headers = {
      "Authorization": '${token}',
      "Content-Type": "application/json"
    };

    final request = Request('GET', uri);
    request.body = '{"name": "$userName"}';
    request.headers.addAll(headers);
    final response = await request.send();
    if (response.statusCode == 200) {
      List<User> searchUsersResponseFromJson(String str) =>
          SearchUsersResponse.fromJson(json.decode(str)).results.users;

      final respStr = await response.stream.bytesToString();
      final searchResponse = searchUsersResponseFromJson(respStr);
      return searchResponse.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
          body: SafeArea(
            child: SearchBar<User>(
              searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
              minimumChars: 0,
              debounceDuration: Duration(milliseconds: 0),
              headerPadding: EdgeInsets.symmetric(horizontal: 10),
              listPadding: EdgeInsets.symmetric(horizontal: 10),
              hintText: AppStrings.searchHint,
              shrinkWrap: true,
              onError: (error) {
                return Center(
                  child: Text(AppStrings.searchResultsNotFound),
                );
              },
              onSearch: fetchSearchUser,
              searchBarController: _searchBarController,
              cancellationWidget: Text("Cancel"),
              emptyWidget: Center(child: Text(AppStrings.noResultsFound)),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 1,
              onItemFound: (User post, int index) {
                return ListTile(
                    onTap: () async {
                      String token = await SecureStorageUtil()
                          .retrieveAuthenticationToken();

                      Result<Profile> profileResult = await ProfileService()
                          .getProfile(userId: post.userid, token: token);

                      setState(() {
                        _textEditingControllerOneToOneEmail.text =
                            profileResult.result.email;
                      });

                      await Navigator.pop(context);

                      setState(() {
                        _textEditingControllerOneToOneEmail.text =
                            profileResult.result.email;
                      });
                    },
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primaryColorLight,
                      child: Icon(
                        Icons.person,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    title: RichText(
                      text: TextSpan(
                        text: post.name,
                        style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold),
                        children: [],
                      ),
                    ));
              },
            ),
          ),
        );
  }
}
