import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/model/eventDetail.dart';
import 'package:nia_app/src/ui/spacers.dart';
import 'package:nia_app/src/ui/widgets/optional_buttons.dart';

class EventDetailPage extends StatefulWidget {
  final EventDetail eventDetail;

  EventDetailPage({Key key, this.eventDetail}) : super(key: key);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  var _eventDetail = EventDetail(
      eventName: 'event_name',
      location: '',
      month: 'Month',
      description: AppStrings.loremIpsum,
      day: 'day',
      dateAndTime: '');

  @override
  Widget build(BuildContext context) {
    final topContent = Stack(
      children: <Widget>[
        _buildEventDetailImage(),
      ],
    );

    final bottomContent = Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: <Widget>[
            _buildTopHeaderRow(),
            AppSpacers.largeVerticalSpacer,
            _buildDescriptionText(),
            AppSpacers.mediumVerticalSpacer,
            _buildDateAndTimeText(),
            AppSpacers.mediumVerticalSpacer,
            _buildLocationText(),
            AppSpacers.largeVerticalSpacer,
            OptionalButtons(
              title: [AppStrings.rsvp, AppStrings.addToCalendar],
              onTap: () {},
            )
          ],
        ),
      ),
    );

    return   Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.eventsDetailPageTitle),
            actions: <Widget>[],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                topContent,
                AppSpacers.mediumVerticalSpacer,
                bottomContent
              ],
            ),
          ),
        );
  }

  Widget _buildEventDetailImage() {
    return AspectRatio(
      aspectRatio: 4 / 2,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                'Cover Photo',
                style: TextStyle(fontSize: 20, color: AppColors.white),
              ),
            ),
          ],
        ),
        color: AppColors.darkGrey,
      ),
    );
  }

  Widget _buildTopHeaderRow() {
    return Row(
      children: <Widget>[
        Column(
          children: [
            Container(
              child: AutoSizeText(
                _eventDetail.month.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: AutoSizeText(
                _eventDetail.day.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        AppSpacers.mediumHorizontalSpacer,
        AutoSizeText(
          _eventDetail.eventName,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDescriptionText() {
    return AutoSizeText(
      _eventDetail.description,
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildDateAndTimeText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AutoSizeText(
          AppStrings.dateAndTime,
        ),
        AppSpacers.smallHorizontalSpacer,
        AutoSizeText(
          _eventDetail.dateAndTime,
        ),
      ],
    );
  }

  Widget _buildLocationText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AutoSizeText(
          AppStrings.location,
        ),
        AppSpacers.smallHorizontalSpacer,
        AutoSizeText(
          _eventDetail.location,
        ),
      ],
    );
  }
}
