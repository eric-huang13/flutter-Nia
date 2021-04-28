import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/ui/spacers.dart';

class OptionalButtons extends StatelessWidget {
  final List<String> title;
  final Function onTap;

  const OptionalButtons({Key key, @required this.title, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  border: Border.all(color: AppColors.white)),
              child: Material(
                color: AppColors.transparent,
                child: InkWell(
                  splashColor: AppColors.white.withOpacity(0.7),
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 18, right: 18),
                    child: Center(
                      child: Text(
                        title[0],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: 0.27,
                            color: AppColors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AppSpacers.mediumHorizontalSpacer,
          new Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.lightGrey.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  border: Border.all(color: AppColors.white)),
              child: Material(
                color: AppColors.transparent,
                child: InkWell(
                  splashColor: AppColors.white.withOpacity(0.7),
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 18, right: 18),
                    child: Center(
                      child: Text(
                        title[1],
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: 0.27,
                            color: AppColors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}