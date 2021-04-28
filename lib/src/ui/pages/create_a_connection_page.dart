import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/ui/spacers.dart';
import 'package:nia_app/src/ui/widgets/bordered_textfield.dart';
import 'package:nia_app/src/ui/widgets/wide_button.dart';

class CreateAConnectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.createAConnection),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.check),
              )
            ],
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
                  BorderedTextField(hintText: AppStrings.recipientName),
                  AppSpacers.largeVerticalSpacer,
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: BorderedTextField(
                              hintText: AppStrings.firstName)),
                      AppSpacers.mediumHorizontalSpacer,
                      Expanded(
                          child:
                              BorderedTextField(hintText: AppStrings.lastName)),
                    ],
                  ),
                  AppSpacers.mediumVerticalSpacer,
                  BorderedTextField(hintText: AppStrings.phoneNumber),
                  AppSpacers.mediumVerticalSpacer,
                  BorderedTextField(hintText: AppStrings.emailAddress),
                  AppSpacers.mediumVerticalSpacer,
                  BorderedTextField(
                      hintText: AppStrings.leaveAMessage, maxLines: 6),
                  AppSpacers.largeVerticalSpacer,
                  WideButton(
                    title: AppStrings.createConnection,
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
