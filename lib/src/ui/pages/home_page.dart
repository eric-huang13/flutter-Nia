import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/model/user_activity_response.dart';
import 'package:nia_app/src/modules/like_post_presenter.dart';
import 'package:nia_app/src/modules/user_activity_presenter.dart';
import 'package:nia_app/src/repo/groups_repo.dart';
import 'package:nia_app/src/ui/pages/action_button_page.dart';
import 'package:nia_app/src/ui/widgets/post_widget.dart';
import 'package:nia_app/src/util/shared_preferences_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    implements UserActivityViewContract, LikePostContract {
  UserActivityViewPresenter _presenter;
  LikePostPresenter _likePostPresenter;
  List<Activity> _userActivityResponse;
  bool _isLoading;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _isLoading = true;
    _presenter
        .loadUserActivity(GroupsRepo.instance.selectedGroup.id.toString());

    _refreshController.refreshCompleted();
  }

  _HomePageState() {
    _presenter = new UserActivityViewPresenter(this);
    _likePostPresenter = new LikePostPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    if (GroupsRepo.instance.selectedGroup != null) {
      _isLoading = true;
      _presenter
          .loadUserActivity(GroupsRepo.instance.selectedGroup.id.toString());
    }
  }

  void _likePost({@required String likeId, @required String app}) async {
    String userId = (await SharedPreferencesUtil().getUserId()).toString();

    if (_userActivityResponse != null) {
      List likesList = (_userActivityResponse.firstWhere(
              (userActivity) => userActivity.likeId.toString() == likeId))
          .likesList;

      if (likesList != null && likesList.isNotEmpty) {
        if (likesList.contains(userId)) {
          _likePostPresenter.unlikePost(likeId: likeId, app: app);
        } else {
          _likePostPresenter.likePost(likeId: likeId, app: app);
        }
      } else {
        _likePostPresenter.likePost(likeId: likeId, app: app);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          key: _scaffoldKey,
          body: _isLoading ==
                  null //If the selected repo is empty, _isLoading is null , so show an empty message
              ? Center(
                  child: Text('No activity available'),
                )
              : _isLoading
                  ? new Center(
                      child: CircularProgressIndicator(),
                    )
                  : SmartRefresher(
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
                      child: ListView.builder(
                        itemCount: _userActivityResponse.length,
                        itemBuilder: (BuildContext context, int index) {
                          _userActivityResponse
                              .sort((a, b) => b.created.compareTo(a.created));

                          return PostWidget(
                            key: UniqueKey(),
                            activity: _userActivityResponse[index],
                            callApiAgainhome: () {
                              _isLoading = true;
                              _presenter.loadUserActivity(GroupsRepo
                                  .instance.selectedGroup.id
                                  .toString());
                            },
                            likePostFunction: _likePost,
                          );
                        },
                      ),
                    ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ActionButtonPage()),
              );
            },
            child: Icon(Icons.add),
          ),
        );
  }

  @override
  void onLoadUserActivityComplete(List<Activity> items) {
    setState(() {
      _userActivityResponse = items;
      // _userActivityResponse = items..sort((a, b) => a.created.compareTo(b.created));
      _isLoading = false;
    });
  }

  @override
  void onLoadUserActivityError() {}

  @override
  void onLikePostError() {
    _showErrorSnackbar(message: AppStrings.couldNotLikePost);
  }

  _showErrorSnackbar({@required message}) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Future<void> onLikePostComplete({bool status, String likeId}) async {
    if (status) {
      String userId = (await SharedPreferencesUtil().getUserId()).toString();

      setState(() {
        Activity currentActivity = (_userActivityResponse.firstWhere(
            (userActivity) => userActivity.likeId.toString() == likeId));

        ++(_userActivityResponse.firstWhere(
                (userActivity) => userActivity.likeId.toString() == likeId))
            .likeCount; //Increment like count locally

        int indexOfActivity = _userActivityResponse.indexOf(currentActivity);

        List tempLikeList = currentActivity.likesList;

        tempLikeList.add(userId);

        _userActivityResponse[indexOfActivity] = Activity(
          app: currentActivity.app,
          likeId: currentActivity.likeId,
          likeCount: currentActivity.likeCount,
          title: currentActivity.title,
          content: currentActivity.content,
          created: currentActivity.created,
          updatedAt: currentActivity.updatedAt,
          id: currentActivity.id,
          actor: currentActivity.actor,
          commentId: currentActivity.commentId,
          eventid: currentActivity.eventid,
          likesList: tempLikeList,
          commentCount: currentActivity.commentCount,
          comments: currentActivity.comments,
          avatar: currentActivity.avatar,
          name: currentActivity.name,
        ); //Add liker to list of likes locally
      });
    } else {
      _showErrorSnackbar(message: AppStrings.couldNotLikePost);
    }
  }

  @override
  Future<void> onUnlikePostComplete({bool status, String likeId}) async {
    if (status) {
      String userId = (await SharedPreferencesUtil().getUserId()).toString();

      setState(() {
        Activity currentActivity = (_userActivityResponse.firstWhere(
            (userActivity) => userActivity.likeId.toString() == likeId));

        --(_userActivityResponse.firstWhere(
                (userActivity) => userActivity.likeId.toString() == likeId))
            .likeCount; //Decrement like count locally

        int indexOfActivity = _userActivityResponse.indexOf(currentActivity);

        List tempLikeList = currentActivity.likesList;

        tempLikeList.remove(userId);

        _userActivityResponse[indexOfActivity] = Activity(
          app: currentActivity.app,
          likeId: currentActivity.likeId,
          likeCount: currentActivity.likeCount,
          title: currentActivity.title,
          content: currentActivity.content,
          created: currentActivity.created,
          updatedAt: currentActivity.updatedAt,
          id: currentActivity.id,
          actor: currentActivity.actor,
          commentId: currentActivity.commentId,
          eventid: currentActivity.eventid,
          likesList: tempLikeList,
          commentCount: currentActivity.commentCount,
          comments: currentActivity.comments,
        ); //Add liker to list of likes locally
      });
    } else {
      _showErrorSnackbar(message: AppStrings.couldNotUnlikePost);
    }
  }

  @override
  void onUnlikePostError() {
    _showErrorSnackbar(message: AppStrings.couldNotUnlikePost);
  }
}
