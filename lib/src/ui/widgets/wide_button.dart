import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_colors.dart';

class WideButton extends StatelessWidget {
  final String title;
  final Function onTap;

  const WideButton({Key key, @required this.title, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: FlatButton(
        color: AppColors.primaryColor,
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            title,
            style: TextStyle(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
