import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/ui/spacers.dart';
import 'package:nia_app/src/ui/widgets/bordered_textfield.dart';
import 'package:nia_app/src/ui/widgets/wide_button.dart';

class ScheduleOneOnOnePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.scheduleAOneOnOne),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: AppColors.primaryColorLight,
                    radius: 30.0,
                    child: Icon(
                      Icons.person,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  AppSpacers.mediumVerticalSpacer,
                  BorderedTextField(hintText: AppStrings.personMeetingWith),
                  AppSpacers.mediumVerticalSpacer,
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: BorderedTextField(
                        hintText: AppStrings.meetingDate,
                        icon: FontAwesome5Regular.calendar_alt,
                      )),
                      AppSpacers.mediumHorizontalSpacer,
                      Expanded(
                          child: BorderedTextField(
                        hintText: AppStrings.meetingTime,
                        icon: Icons.access_time,
                      )),
                    ],
                  ),
                  AppSpacers.mediumVerticalSpacer,
                  BorderedTextField(
                    hintText: AppStrings.meetingAddress,
                    icon: Icons.location_on,
                  ),
                  AppSpacers.largeVerticalSpacer,
                  WideButton(
                    title: AppStrings.scheduleOneToOne,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
        );
  }
}
