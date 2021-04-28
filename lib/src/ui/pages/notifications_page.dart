import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/model/notification.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({
    Key key,
  }) : super(key: key);

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _refreshController.refreshCompleted();
  }

  final List<NotificationModel> _notificationList = [];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          body: _notificationList.isEmpty
              ? Center(
                  child: Text('No notifications yet'),
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
                    itemCount: _notificationList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return NotificationsWidget(
                        notification: _notificationList.elementAt(index),
                      );
                    },
                  )),
        );
  }
}

class NotificationsWidget extends StatelessWidget {
  final NotificationModel notification;

  const NotificationsWidget({
    Key key,
    @required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.veryLightGrey,
      child: ListTile(
        leading: AspectRatio(
          aspectRatio: 1.0,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Icon(Icons.image),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  backgroundColor: AppColors.darkGrey,
                  radius: 8.0,
                  child: CircleAvatar(
                    backgroundColor: AppColors.lightGrey,
                    radius: 4.0,
                  ),
                ),
              )
            ],
          ),
        ),
        title: RichText(
          text: TextSpan(
            text: notification.username + ' ',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: AppColors.black),
            children: <TextSpan>[
              TextSpan(
                  text: notification.actionString,
                  style: TextStyle(fontWeight: FontWeight.w400)),
            ],
          ),
        ),
        subtitle: Text(notification.time),
        trailing: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 16.0,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
