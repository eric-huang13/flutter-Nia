import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';

class PostAnUpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.newPost),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.check),
              )
            ],
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
                    hintText: AppStrings.whatsOnYourMind,
                    border: InputBorder.none,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: AppColors.lightGrey,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.videocam,
                      color: AppColors.lightGrey,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.location_on,
                      color: AppColors.lightGrey,
                    ),
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        );
  }
}
