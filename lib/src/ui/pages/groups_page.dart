import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/model/group.dart';
import 'package:nia_app/src/model/result.dart';
import 'package:nia_app/src/repo/groups_repo.dart';
import 'package:nia_app/src/services/groups_service.dart';
import 'package:nia_app/src/ui/widgets/group_widget.dart';
import 'package:nia_app/src/util/secure_storage_util.dart';
import 'package:nia_app/src/util/shared_preferences_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GroupsPage extends StatefulWidget {
  final Function onGroupTap;

  GroupsPage({
    Key key,
    @required this.onGroupTap,
  }) : super(key: key);

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  void initState() {
    super.initState();
    if (GroupsRepo.instance.groupList.isEmpty) {
      //Only fetch groups if the list of groups in the repo is empty
      _fetchGroups();
    }
  }

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _isLoading = true;
    _fetchGroups();

    _refreshController.refreshCompleted();
  }


  _fetchGroups() async {
    setState(() {
      _isLoading = true;
    });
    int userId = await SharedPreferencesUtil().getUserId();
    String token = await SecureStorageUtil().retrieveAuthenticationToken();

    Result<List<Group>> groupListResult =
        await GroupService().getGroups(userId: userId, token: token);

    if (groupListResult.result == null) {
      setState(() {
        _isLoading = false;
      });
      _showLoginErrorSnackbar(message: groupListResult.message);
    } else {
      setState(() {
        _isLoading = false;

        GroupsRepo.instance.groupList = groupListResult.result;
      });
    }
  }

  _showLoginErrorSnackbar({@required message}) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    List<Group> groupList = GroupsRepo.instance.groupList;

    Widget _getBody() {
      if (_isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        if (groupList.isNotEmpty) {
          return

              SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: MaterialClassicHeader(),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = Text("pull up load");
                    } else if (mode == LoadStatus.loading) {
                      body = CircularProgressIndicator();
                    } else if (mode == LoadStatus.failed) {
                      body = Text("Load Failed!Click retry!");
                    } else if (mode == LoadStatus.canLoading) {
                      body = Text("release to load more");
                    } else {
                      body = Text("No more Data");
                    }
                    return Container(
                      height: 55.0,
                      child: Center(child: body),
                    );
                  },
                ),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child:   ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: groupList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GroupWidget(
                        group: groupList.elementAt(index), onTap: widget.onGroupTap);
                  },
                )
            )
          ;
        } else {
          return Center(
            child: Text('No groups available'),
          );
        }
      }
    }

    return  Scaffold(
          key: _scaffoldKey,
          body: _getBody(),
        );
  }
}
