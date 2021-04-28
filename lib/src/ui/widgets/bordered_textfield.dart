import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_colors.dart';

class BorderedTextField extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final bool enabled;
  final IconData icon;
  final TextEditingController controller;

  const BorderedTextField(
      {Key key, @required this.hintText, this.maxLines = 1, this.icon,this.controller,this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 14.0,
      ),
      decoration: InputDecoration(
          suffixIcon: Icon(icon, color: AppColors.primaryColorLight),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.primaryColor, width: 0.0)),
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.primaryColor.withOpacity(0.7))),
    );
  }
}