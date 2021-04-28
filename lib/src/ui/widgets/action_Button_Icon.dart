import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_colors.dart';

class ActionButtonIcon extends StatelessWidget {
  const ActionButtonIcon({
    Key key,
    @required this.icon,
  }) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 23),
        child: CircleAvatar(
            radius: 23,
            backgroundColor: AppColors.primaryColor,
            child: Icon(
              icon,
              color: AppColors.white,
            )));
  }
}