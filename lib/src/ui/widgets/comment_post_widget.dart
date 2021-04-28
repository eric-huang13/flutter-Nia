import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/data/app_strings.dart';
import 'package:nia_app/src/model/user_activity_response.dart';
import 'package:nia_app/src/ui/pages/comment_page.dart';
import 'package:nia_app/src/ui/spacers.dart';
import 'package:nia_app/src/util/en_short_messages_util.dart';
import 'package:nia_app/src/util/shared_preferences_util.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../util/extensions_util.dart';

class CommentPostWidget extends StatefulWidget {
  const CommentPostWidget({
    Key key,
    @required this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  State<StatefulWidget> createState() => _CommentPostWidgetState();
}

class _CommentPostWidgetState extends State<CommentPostWidget> {
  bool isUserIdInLikesList;
  final GlobalKey _cardKey = GlobalKey();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _checkIfUserIdIsInLikesList();
  }

  void _checkIfUserIdIsInLikesList() async {
    String userId = (await SharedPreferencesUtil().getUserId()).toString();


    setState(() {
      isUserIdInLikesList = widget.activity.likesList.contains(userId);
    });
  }
  Size cardSize;
  Offset cardPosition;

  getSizeAndPosition() {
    RenderBox _cardBox = _cardKey.currentContext.findRenderObject();
    cardSize = _cardBox.size;
    cardPosition = _cardBox.localToGlobal(Offset.zero);
    print(cardSize);
    print(cardPosition);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getSizeAndPosition());
  }

  @override
  Widget build(BuildContext context) {
    // Override a locale message
    timeago.setLocaleMessages('en', EnShortMessage());
    return Container(
      color: AppColors.white,
      child: Card(
        key: _cardKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTopRow(),
              AppSpacers.mediumVerticalSpacer,
              buildPostText(),
              widget.activity.content.isNullOrEmpty()
                  ? AppSpacers.mediumVerticalSpacer
                  : _buildPostImage(),
              AppSpacers.mediumVerticalSpacer,
              AppSpacers.mediumVerticalSpacer,
              _buildBottomRow()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPostText() {
    return Expanded(
      child: AutoSizeText(
        widget.activity.title,
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildPostImage() {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        color: AppColors.primaryColor.withOpacity(0.5),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage:
                CachedNetworkImageProvider(widget.activity.avatar),
              ),
              AppSpacers.smallHorizontalSpacer,
              Expanded(
                child: AutoSizeText(
                  widget.activity.name,
                  softWrap: true,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        AutoSizeText(
          timeago.format(widget.activity.created, locale: 'en'),
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildBottomRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //Likes
              LikesReactionWidget(
                likes: widget.activity.likeCount.toString(),
                isUserIdInLikesList: isUserIdInLikesList,
              ),
              AppSpacers.mediumHorizontalSpacer,
              //Comments
              CommentsReactionWidget(
                post: widget.activity,
                cardSize: cardSize
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LikesReactionWidget extends StatelessWidget {
  final String likes;
  final bool isUserIdInLikesList;

  const LikesReactionWidget(
      {Key key, @required this.likes, @required this.isUserIdInLikesList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            isUserIdInLikesList.isNullOrFalse()
                ? MaterialCommunityIcons.heart_outline
                : MaterialCommunityIcons.heart,
            color: AppColors.primaryColor,
          ),
          AppSpacers.smallHorizontalSpacer,
          Text(likes,
              style: TextStyle(
                color: AppColors.primaryColor,
              )),
        ],
      ),
    );
  }
}

class CommentsReactionWidget extends StatelessWidget {
  final Activity post;
  final Size cardSize;

  const CommentsReactionWidget({
    Key key,
    @required this.post,this.cardSize
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.chat,
            color: AppColors.primaryColor,
          ),
          AppSpacers.smallHorizontalSpacer,
          Text("${post.commentCount}",
              style: TextStyle(
                color: AppColors.primaryColor,
              )),
        ],
      ),
    );
  }
}
