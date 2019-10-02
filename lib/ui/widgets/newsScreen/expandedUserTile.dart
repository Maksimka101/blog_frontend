import 'package:blog_frontend/bloc/newsFeedBloc.dart';
import 'package:blog_frontend/events/newsEvent.dart';
import 'package:blog_frontend/ui/entity/uiUserEntity.dart';
import 'package:blog_frontend/ui/widgets/common/userTile.dart';
import 'package:flutter/material.dart';

class ExpandedUserTile extends StatefulWidget {
  ExpandedUserTile(
      {@required this.users,
      @required this.newsBloc,
      @required this.currentUserIndex,
      this.expandDuration = const Duration(milliseconds: 400)});

  final List<UiUserEntity> users;
  final int currentUserIndex;
  final NewsFeedBloc newsBloc;
  final Duration expandDuration;

  @override
  _ExpandedUserTileState createState() => _ExpandedUserTileState();
}

class _ExpandedUserTileState extends State<ExpandedUserTile>
    with TickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
          reverseDuration: widget.expandDuration,
          alignment: Alignment.topCenter,
          duration: widget.expandDuration,
          vsync: this,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                UserTile(
                  userName: widget.users[widget.currentUserIndex].userName,
                  imageUrl: widget.users[widget.currentUserIndex].userImageUrl,
                  onClick: () => setState(() => _isExpanded = !_isExpanded),
                ),
                if (_isExpanded)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Divider(
                        indent: 5,
                        endIndent: 5,
                      ),
                      UserTile(
                        userName: 'Посты всех пользователей',
                        onClick: () {
                          widget.newsBloc.addPostEvent
                              .add(EventFilterUsers(showAllUsers: true));
                        },
                      ),
                      Divider(
                        indent: 5,
                        endIndent: 5,
                      ),
                      for (final user in widget.users)
                        UserTile(
                          userName: user.userName,
                          imageUrl: user.userImageUrl,
                          onClick: () {
                            widget.newsBloc.addPostEvent.add(EventFilterUsers(
                                showAllUsers: false, userName: user.userName));
                          },
                        )
                    ],
                  ),
              ],
            ),
          ),
        );
  }
}
