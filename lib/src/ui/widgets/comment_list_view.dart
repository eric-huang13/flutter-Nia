import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/model/user_activity_response.dart';

class CommentsListItem extends StatelessWidget {
  const CommentsListItem(
      {Key key,
      this.comment,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final Comment comment;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  callback();
                },
                child: getReceivedMessageLayout(comment),
              ),
            ),
          ),
        );
      },
    );
  }
}
Widget getReceivedMessageLayout(Comment comment) {
  return Container(
    child: Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      child: new  CircleAvatar(
                        backgroundImage:
                        CachedNetworkImageProvider(comment.avatar),
                        radius: 20.0,
                      )),
                ],
              ),
            ),
          ],
        ),
        new Expanded(
          child: Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(10.0),
              color: AppColors.veryLightGrey,


            ),

            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16,left: 16),
                  child: new Text("${comment.name}",
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const  EdgeInsets.only(top: 0,left: 16,bottom: 16, right: 16),
                  child: new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: Text("${comment.comment}")
                  ),

                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
