import 'dart:convert';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/model/group.dart';
import 'package:nia_app/src/repo/groups_repo.dart';
import 'package:nia_app/src/repo/profile_repo.dart';
import 'package:nia_app/src/ui/pages/events_page.dart';
import 'package:nia_app/src/ui/pages/groups_page.dart';
import 'package:nia_app/src/ui/pages/home_page.dart';
import 'package:nia_app/src/ui/pages/login_page.dart';
import 'package:nia_app/src/ui/pages/notifications_page.dart';
import 'package:nia_app/src/ui/pages/profile_page.dart';
import 'package:nia_app/src/ui/pages/search.dart';
import 'package:nia_app/src/ui/spacers.dart';
import 'package:nia_app/src/ui/widgets/groups_select_bottom_sheet.dart';
import 'package:nia_app/src/util/secure_storage_util.dart';
import 'package:nia_app/src/util/shared_preferences_util.dart';

class MainPage extends StatefulWidget {
  final int initialPageIndex;

  const MainPage({Key key, this.initialPageIndex = 0}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double appBarElevation = 0.0;
  int _selectedIndex;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  var _homePage;
  var _groupsPage;
  var _eventsPage = EventsPage();
  var _notificationsPage = NotificationsPage();
  var _profilePage = ProfilePage(
    isSelfProfile: true,
  );

  static List<Widget> _pages;

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.initialPageIndex;

    _homePage = HomePage();
    _groupsPage = GroupsPage(
      onGroupTap: () => _onItemTapped(
          0), //This switches the tab to the first tab i.e home screen
    );
    _pages = <Widget>[
      _homePage,
      _groupsPage,
      _eventsPage,
      _notificationsPage,
      _profilePage,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: AppColors.white,
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: SizedBox.shrink(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                AntDesign.appstore1,
                size: 18.0,
              ),
              title: SizedBox.shrink(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesome5Regular.calendar_alt,
                size: 18.0,
              ),
              title: SizedBox.shrink(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: SizedBox.shrink(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: SizedBox.shrink(),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.darkGrey,
          onTap: _onItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 16.0,
          type: BottomNavigationBarType.fixed),
    );
  }

  AppBar _buildAppBar() {
    //The profile page has a different app bar from the others
    if (_selectedIndex == _pages.indexOf(_profilePage)) {
      return _buildProfilePageappBar();
    } else {
      return _buildGeneralAppBar();
    }
  }

  AppBar _buildProfilePageappBar() {
    return AppBar(
      elevation: appBarElevation,
      backgroundColor: AppColors.white,
      title: Text(AppStrings.profilePageTitle,
          style: TextStyle(color: AppColors.primaryColor)),
      centerTitle: true,
      actions: <Widget>[
        PopupMenuButton(
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: AppStrings.signOut,
              child: Text(AppStrings.signOut),
            ),
          ],
          child: Icon(
            Icons.more_vert,
            color: AppColors.primaryColor,
          ),
          onSelected: (selection) async {
            print('$selection selected');
            if (selection == AppStrings.signOut) {
              await SecureStorageUtil().removeAuthenticationToken();
              await SharedPreferencesUtil()
                  .setUserLogInStatus(loginStatus: false);
              await SharedPreferencesUtil().removeUserId();

//TODO move logic to individual repo
              GroupsRepo.instance.selectedGroup = null;
              GroupsRepo.instance.groupList = [];
              ProfileRepo.instance.profile = null;

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          },
        ),
      ],
    );
  }

  _switchSelectedGroup(Group group) {
    setState(() {
      GroupsRepo.instance.selectedGroup = group;
    });
  }

  AppBar _buildGeneralAppBar() {
    Widget _getAppBarTitle() {
      Widget appBarTitleWidget;

      if (_selectedIndex == _pages.indexOf(_homePage)) {
        appBarTitleWidget = GestureDetector(
          onTap: () {
            showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              context: context,
              builder: (context) => FractionallySizedBox(
                  heightFactor: 0.5,
                  child:
                      GroupsSelectBottomSheet(onItemTap: _switchSelectedGroup)),
            );
          },
          child: Row(
            children: <Widget>[
              Text(GroupsRepo.instance.selectedGroup == null
                  ? 'No groups available'
                  : GroupsRepo.instance.selectedGroup.name),
              AppSpacers.extraSmallHorizontalSpacer,
              RotatedBox(
                quarterTurns: 3,
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 16.0,
                ),
              )
            ],
          ),
        );
      }
      if (_selectedIndex == _pages.indexOf(_groupsPage)) {
        appBarTitleWidget = Text(AppStrings.groupPageTitle);
      }
      if (_selectedIndex == _pages.indexOf(_eventsPage)) {
        appBarTitleWidget = Text(AppStrings.eventsPageTitle);
      }
      if (_selectedIndex == _pages.indexOf(_notificationsPage)) {
        appBarTitleWidget = Text(AppStrings.notificationsPageTitle);
      }

      return appBarTitleWidget;
    }

    return AppBar(
      elevation: appBarElevation,
      title: _getAppBarTitle(),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Search()));
            }),
      ],
    );
  }
}
