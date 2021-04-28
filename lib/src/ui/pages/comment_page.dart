import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nia_app/src/data/app_colors.dart';
import 'package:nia_app/src/model/post_user_activity_comment_response.dart';
import 'package:nia_app/src/model/user_activity_response.dart';
import 'package:nia_app/src/modules/comment_post_presenter.dart';
import 'package:nia_app/src/ui/pages/main_page.dart';
import 'package:nia_app/src/ui/pages/search.dart';
import 'package:nia_app/src/ui/widgets/comment_list_view.dart';
import 'package:nia_app/src/ui/widgets/comment_post_widget.dart';
import 'package:nia_app/src/ui/widgets/post_widget.dart';
import 'package:nia_app/src/util/shared_preferences_util.dart';

var _scaffoldContext;

class CommentPage extends StatefulWidget {
  final Activity userPost;
  final Size cardSize;
  final VoidCallback callApiAgain;
  const CommentPage(
      {Key key, this.userPost, this.cardSize, @required this.callApiAgain})
      : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage>
    with TickerProviderStateMixin
    implements CommentPostViewContract {
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _isComposingMessage = false;
  CommentPostViewPresenter _presenter;
  PostUserActivityCommentResponse _userActivityResponse;
  var animationTemp;

  var indextemp;

  _CommentPageState() {
    _presenter = new CommentPostViewPresenter(this);
  }

  AnimationController animationController;

  final ScrollController _scrollController = ScrollController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  List<Comment> _commentList = [];
  Activity _userPost;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _commentList = widget.userPost.comments;
    _userPost = widget.userPost;

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  _showSnackbar({@required message}) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 0.0,
            title: Text(""),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Search()));
                  }),
//              IconButton(
//                icon: Icon(Icons.mail),
//                onPressed: () {},
//              ),
            ],
          ),
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  // FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverPersistentHeader(
                              pinned: true,
                              floating: true,
                              delegate: ContestTabHeader(
                                  CommentPostWidget(activity: _userPost),
                                  widget.cardSize.height),
                            )
                          ];
                        },
                        body: (_commentList == null || _commentList.isEmpty)
                            ? SizedBox.shrink()
                            : Container(
                                color: AppColors.white,
                                child: ListView.builder(
                                  itemCount: _commentList.length,
                                  padding: const EdgeInsets.only(top: 8),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final int count = _commentList.length > 10
                                        ? 10
                                        : _commentList.length;
                                    final Animation<double> animation =
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(CurvedAnimation(
                                                parent: animationController,
                                                curve: Interval(
                                                    (1 / count) * index, 1.0,
                                                    curve:
                                                        Curves.fastOutSlowIn)));
                                    animationTemp = animation;
                                    indextemp = index;
                                    animationController.forward();
                                    return CommentsListItem(
                                      callback: () {},
                                      comment: _commentList[index],
                                      animation: animation,
                                      animationController: animationController,
                                    );
                                  },
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildTextComposer()),
    );
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
        data: new IconThemeData(
          color: _isComposingMessage
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () async {}),
              ),
              Flexible(
                child: TextField(
                  controller: _textEditingController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.length > 0;
                    });
                  },
                  onSubmitted: _textMessageSubmitted,
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? getIOSSendButton()
                    : getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });

    _sendMessage(messageText: text, imageUrl: null);
  }

  void _sendMessage({String messageText, String imageUrl}) {
    setState(() {
      _presenter.postComment(_userPost.commentId, _userPost.app, messageText);
      print("loading ");
    });
  }

  @override
  Future<void> onCommentPostComplete(
      {PostUserActivityCommentResponse postUserActivityCommentResponse,
      int commentId,
      String comment}) async {
    String userId = (await SharedPreferencesUtil().getUserId()).toString();

    setState(() {
      _userActivityResponse = postUserActivityCommentResponse;

      if (postUserActivityCommentResponse.success.affectedRows > 0) {
        _showSnackbar(message: "Comment sent is $comment");

        _commentList.add(Comment(comment: comment, postBy: int.parse(userId)));
        _userPost.comments = _commentList;
        ++_userPost.commentCount; //Increment comment count

        widget.callApiAgain();
      } else {
        _showSnackbar(message: "Comment not Sent...Try again later");
      }
    });
  }

  @override
  void onCommentPostError() {
    // TODO: implement onCommentPostError
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(this.postUI, this.postY);

  final Widget postUI;
  final double postY;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return postUI;
  }

  @override
  double get maxExtent => postY;

  @override
  double get minExtent => postY;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
