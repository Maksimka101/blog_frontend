import 'package:blog_frontend/bloc/newsFeedBloc.dart';
import 'package:blog_frontend/events/newsEvent.dart';
import 'package:blog_frontend/model/contants.dart';
import 'package:blog_frontend/ui/entity/uiUserEntity.dart';
import 'package:blog_frontend/ui/widgets/common/roundedCard.dart';
import 'package:blog_frontend/ui/widgets/common/userTile.dart';
import 'package:flutter/material.dart';

class ExpandedUserCard extends StatefulWidget {
  ExpandedUserCard(
      {@required this.users,
      @required this.newsBloc,
      @required this.currentUserIndex,
      this.expandDuration = const Duration(milliseconds: 400)});

  final List<UiUserEntity> users;
  final int currentUserIndex;
  final NewsFeedBloc newsBloc;
  final Duration expandDuration;

  @override
  _ExpandedUserCardState createState() => _ExpandedUserCardState();
}

class _ExpandedUserCardState extends State<ExpandedUserCard>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  var _isDisposed = false;
  var _sizeFactor = 1.0;

  @override
  void initState() {
    if (widget.currentUserIndex != 0)
      _sizeFactor = 0.5;
    Future.delayed(Duration())
        .then((_) => widget.newsBloc.scrollPosition.listen(_listenForPage));
    super.initState();
  }

  void _listenForPage(double position) {
    final abs = (widget.currentUserIndex - position).abs();
    if (abs <= 1.3 && !_isDisposed && abs >= 0.5)
      setState(() {
        _sizeFactor = 0.5 + (1 - abs);
        _isExpanded = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height-toolAndAppBarHeight,
      ),
      child: FractionallySizedBox(
        widthFactor: _sizeFactor,
        child: AnimatedSize(
          reverseDuration: widget.expandDuration,
          alignment: Alignment.topCenter,
          duration: widget.expandDuration,
          vsync: this,
          child: RoundedCard(
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
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
