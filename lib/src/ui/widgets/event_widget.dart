import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/model/event.dart';
import 'package:nia_app/src/model/eventDetail.dart';
import 'package:nia_app/src/ui/pages/event_detail_page.dart';
import 'package:nia_app/src/ui/spacers.dart';

class EventWidget extends StatelessWidget {
  final Event event;

  const EventWidget({Key key, @required this.event}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var _eventDetailList =  EventDetail(
        eventName: 'event_name',
        location: '',
        month: 'Month',
        description: AppStrings.loremIpsum,
        day: 'day',
        dateAndTime: ''
      );
    return Container(
      margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
      decoration: BoxDecoration(border: Border.all()),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Spacer(
              flex: 2,
            ),
            VerticalDivider(
              color: AppColors.primaryColor,
              thickness: 1.0,
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppSpacers.smallVerticalSpacer,
                  Text(
                    event.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  AppSpacers.mediumVerticalSpacer,
                  Text(
                    event.location,
                  ),
                  AppSpacers.smallVerticalSpacer,
                  Text(
                    event.time,
                  ),
                  AppSpacers.mediumVerticalSpacer,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        color: AppColors.primaryColor,
                        textColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventDetailPage(eventDetail: _eventDetailList,)));
                        },
                        child: Text(AppStrings.rsvp),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
