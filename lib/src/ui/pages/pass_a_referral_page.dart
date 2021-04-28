import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/model/lead_swap.dart';
import 'package:nia_app/src/model/profile.dart';
import 'package:nia_app/src/model/result.dart';
import 'package:nia_app/src/model/search_users_Response.dart';
import 'package:nia_app/src/modules/lead_swap_presenter.dart';
import 'package:nia_app/src/repo/profile_repo.dart';
import 'package:nia_app/src/services/profile_service.dart';
import 'package:nia_app/src/ui/spacers.dart';
import 'package:nia_app/src/ui/widgets/bordered_textfield.dart';
import 'package:nia_app/src/ui/widgets/wide_button.dart';
import 'package:nia_app/src/util/secure_storage_util.dart';
import 'package:nia_app/src/util/shared_preferences_util.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

String leadInstructions;
final TextEditingController recipientNameController = TextEditingController();
final TextEditingController recipientIdController = TextEditingController();
final TextEditingController recipientController = TextEditingController();

class PassAReferralPage extends StatefulWidget {
  @override
  _PassAReferralPageState createState() => _PassAReferralPageState();
}

class _PassAReferralPageState extends State<PassAReferralPage>
    implements LeadSwapViewContract {
  List<String> _meetingTypeList = [
    "Call Immediately",
    "Call in a day",
    "Call in a few days",
    "Prospect will call you",
  ];

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController prospectPhoneNumberController =
      TextEditingController();
  final TextEditingController prospectEmailAddressController =
      TextEditingController();
  final TextEditingController estimatedValueController =
      TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  LeadSwapViewPresenter _presenter;
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  bool isLoading = false;

  _PassAReferralPageState() {
    _presenter = new LeadSwapViewPresenter(this);
  }

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

  @override
  Widget build(BuildContext context) {
    Profile profile = ProfileRepo.instance.profile;
    return  Scaffold(
          key: _scaffoldkey,
          appBar: AppBar(
            title: Text(AppStrings.passAReferral),
          ),
          body: _isLoading == true
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(profile.avatar),
                          radius: 50.0,
                        ),
                        AppSpacers.mediumVerticalSpacer,

                        TextFormField(
                          controller: recipientNameController,
                          enableInteractiveSelection: false,
                          readOnly: true,
                          onTap: () {
                            Alert(
                                context: context,
                                title: "Find Recipient",
                                content: SizedBox(
                                  height: 500,
                                  width: 500,
                                  child: new SearchRecipientNameUsers(),
                                ),
                                buttons: []).show();
                          },
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                          focusNode: FocusNode(),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primaryColor,
                                      width: 0.0)),
                              hintText: AppStrings.recipientName,
                              hintStyle: TextStyle(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.7))),
                        ),

                        AppSpacers.mediumVerticalSpacer,
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: BorderedTextField(
                              hintText: AppStrings.firstName,
                              controller: firstNameController,
                            )),
                            AppSpacers.mediumHorizontalSpacer,
                            Expanded(
                                child: BorderedTextField(
                              hintText: AppStrings.lastName,
                              controller: lastNameController,
                            )),
                          ],
                        ),
                        AppSpacers.mediumVerticalSpacer,
                        BorderedTextField(
                          hintText: AppStrings.prospectPhoneNumber,
                          controller: prospectPhoneNumberController,
                        ),
                        AppSpacers.mediumVerticalSpacer,
                        BorderedTextField(
                          hintText: AppStrings.prospectEmailAddress,
                          controller: prospectEmailAddressController,
                        ),
                        AppSpacers.mediumVerticalSpacer,
                        RadioButtonGroup(
                            labels: _meetingTypeList,
                            onChange: (String label, int index) => {
                                  if (index == 0) {leadInstructions = "Call Immediately"},
                                  if (index == 1) {leadInstructions = "Call in a day"},
                                  if (index == 2) {leadInstructions = "Call in a few days"},
                                  if (index == 3) {leadInstructions = "Prospect will call you"},
                                },
                            onSelected: (String selected) => print(selected)),
                        AppSpacers.mediumVerticalSpacer,
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: BorderedTextField(
                              hintText: AppStrings.estimatedValue,
                              controller: estimatedValueController,
                            )),
                            AppSpacers.mediumHorizontalSpacer,
                            Expanded(
                                child: BorderedTextField(
                              hintText: "Status - New",
                              enabled: false,
                            )),
                          ],
                        ),
                        AppSpacers.mediumVerticalSpacer,
                        BorderedTextField(
                          hintText: AppStrings.notes,
                          controller: notesController,
                          maxLines: 4,
                        ),
                        AppSpacers.mediumVerticalSpacer,
                        isLoading == false
                            ? WideButton(
                                title: AppStrings.passAReferral,
                                onTap: () {
                                  _presenter.postLeadSwap(
                                      recipientNameController.text,
                                      firstNameController.text,
                                      lastNameController.text,
                                      prospectPhoneNumberController.text,
                                      prospectEmailAddressController.text,
                                      estimatedValueController.text,
                                      notesController.text,
                                      statusController.text,
                                      leadInstructions,
                                      recipientIdController.text,
                                      recipientController.text);
                                  setState(() {
                                    isLoading = true;
                                  });
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              )
                      ],
                    ),
                  ),
                ),
        );
  }

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
  onLoadLeadSwapComplete(LeadSwapResponse swapLeadResult) {
    setState(() {
      isLoading = false;
    });

    if (swapLeadResult.success == true) {
      showSnackBar(AppStrings.submitted);
      print("Yes");
    } else {
      print("No");
      showSnackBar(AppStrings.notSubmitted);
    }
  }

  @override
  onLoadLeadSwapError() {
    return null;
  }
}

class SearchRecipientNameUsers extends StatefulWidget {
  @override
  _SearchRecipientNameUsersState createState() =>
      _SearchRecipientNameUsersState();
}

class _SearchRecipientNameUsersState extends State<SearchRecipientNameUsers> {
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
    return  
     Scaffold(
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
                        recipientNameController.text = post.name;
                        recipientIdController.text = "${post.userid}";
                        recipientController.text =
                            "${profileResult.result.email}";
                      });

                      await Navigator.pop(context);

                      setState(() {
                        recipientNameController.text = post.name;
                        recipientIdController.text = "${post.userid}";
                        recipientController.text =
                            "${profileResult.result.email}";
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
