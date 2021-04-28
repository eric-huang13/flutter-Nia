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

class PostWidget extends StatefulWidget {
  const PostWidget(
      {Key key,
      @required this.activity,
      @required this.callApiAgainhome,
      @required this.likePostFunction})
      : super(key: key);

  final VoidCallback callApiAgainhome;
  final Activity activity;
  final Function likePostFunction;

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isUserIdInLikesList;
  final GlobalKey _cardKey = GlobalKey();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _checkIfUserIdIsInLikesList();
  }

  void _checkIfUserIdIsInLikesList() async {
    String userId = (await SharedPreferencesUtil().getUserId()).toString();

    if (widget.activity.likesList != null) {
        isUserIdInLikesList = widget.activity.likesList.contains(userId);
    }
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
    return Card(
      key: _cardKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
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
    );
  }

  Widget buildPostText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: Text(
                    widget.activity.name,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Text(
            timeago.format(widget.activity.created, locale: 'en'),
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: <Widget>[
              (widget.activity.likeCount == 0 ||
                      widget.activity.likeCount == null)
                  ? SizedBox.shrink()
                  : Row(
                      children: [
                        Icon(
                          MaterialCommunityIcons.heart,
                          color: AppColors.primaryColor,
                        ),
                        AppSpacers.smallHorizontalSpacer,
                        Text(
                          widget.activity.likeCount.toString(),
                          style: TextStyle(
                            color: AppColors.primaryColor,
                          ),
                        )
                      ],
                    ),
              (widget.activity.likeCount == 0 ||
                      widget.activity.likeCount == null)
                  ? SizedBox.shrink()
                  : AppSpacers.mediumHorizontalSpacer,
              Row(
                children: <Widget>[
                  Icon(
                    Icons.chat,
                    color: AppColors.primaryColor,
                  ),
                  AppSpacers.smallHorizontalSpacer,
                  Text(widget.activity.commentCount.toString(),
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      )),
                ],
              )
            ],
          ),
        ),
        Divider(
          indent: 0.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: <Widget>[
              //Likes
              Expanded(
                child: LikesReactionWidget(
                  isUserIdInLikesList: isUserIdInLikesList,
                  likePostFunction: () => widget.likePostFunction(
                      likeId: widget.activity.likeId.toString(),
                      app: widget.activity.app),
                ),
              ),

              //Comments

              Expanded(
                child: CommentsReactionWidget(
                  post: widget.activity,
                  cardSize: cardSize,
                  callApiAgainhome: () {
                    widget.callApiAgainhome();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LikesReactionWidget extends StatelessWidget {
  final bool isUserIdInLikesList;
  final Function likePostFunction;

  const LikesReactionWidget(
      {Key key,
      @required this.isUserIdInLikesList,
      @required this.likePostFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: likePostFunction,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            isUserIdInLikesList.isNullOrFalse()
                ? MaterialCommunityIcons.heart_outline
                : MaterialCommunityIcons.heart,
            color: AppColors.darkGrey,
          ),
          AppSpacers.smallHorizontalSpacer,
          Text('like',
              style: TextStyle(
                color: AppColors.darkGrey,
              )),
        ],
      ),
    );
  }
}

class CommentsReactionWidget extends StatelessWidget {
  final Activity post;
  final Size cardSize;
  final VoidCallback callApiAgainhome;
  const CommentsReactionWidget(
      {Key key,
      @required this.post,
      this.cardSize,
      @required this.callApiAgainhome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => CommentPage(
              userPost: post,
              cardSize: cardSize,
              callApiAgain: () {
                callApiAgainhome();
              },
            ),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.chat,
            color: AppColors.darkGrey,
          ),
          AppSpacers.smallHorizontalSpacer,
          Text('comment',
              style: TextStyle(
                color: AppColors.darkGrey,
              )),
        ],
      ),
    );
  }
}
