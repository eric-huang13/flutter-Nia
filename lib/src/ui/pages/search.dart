import 'dart:convert';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/model/search_users_Response.dart';
import 'package:nia_app/src/ui/pages/profile_page.dart';
import 'package:nia_app/src/util/secure_storage_util.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
    return  Scaffold(
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
                    onTap: () {
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => ProfilePage(isSelfProfile: false, memberId: post.userid),
                        ),
                      );
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
