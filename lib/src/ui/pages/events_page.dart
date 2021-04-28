import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/model/event.dart';
import 'package:nia_app/src/ui/widgets/event_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EventsPage extends StatelessWidget {
  EventsPage({
    Key key,
  }) : super(key: key);

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _refreshController.refreshCompleted();
  }

  final List<Event> _eventList = [];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          body: SmartRefresher(
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
              child: _eventList.isEmpty
                  ? Center(
                      child: Text('No events to display'),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(32.0),
                      itemCount: _eventList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return EventWidget(event: _eventList.elementAt(index));
                      },
                    )),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        );
  }
}
