import 'package:blog_frontend/bloc/newsFeedBloc.dart';
import 'package:blog_frontend/events/newsEvent.dart';
import 'package:blog_frontend/ui/entity/uiUserEntity.dart';
import 'package:blog_frontend/ui/widgets/roundedCard.dart';
import 'package:blog_frontend/ui/widgets/userTile.dart';
import 'package:flutter/material.dart';

class ExpandedUserCard extends StatefulWidget {
  ExpandedUserCard(
      {@required this.users,
      @required this.newsBloc,
      this.duration = const Duration(milliseconds: 350)});
  final List<UserUiEntity> users;
  final NewsFeedBloc newsBloc;
  final Duration duration;

  @override
  _ExpandedUserCardState createState() => _ExpandedUserCardState();
}

class _ExpandedUserCardState extends State<ExpandedUserCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      reverseDuration: widget.duration,
      alignment: Alignment.topCenter,
      duration: widget.duration,
      vsync: this,
      child: RoundedCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Todo
            UserTile(
              userName: widget.users[0].name,
              imageUrl: widget.users[0].imageUrl,
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
                      userName: user.name,
                      imageUrl: user.imageUrl,
                      onClick: () {
                        widget.newsBloc.addPostEvent.add(EventFilterUsers(
                            showAllUsers: false, userName: user.name));
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
