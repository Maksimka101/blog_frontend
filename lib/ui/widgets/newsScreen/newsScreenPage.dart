import 'package:blog_frontend/bloc/newsFeedBloc.dart';
import 'package:blog_frontend/events/newsEvent.dart';
import 'package:blog_frontend/ui/entity/uiUserEntity.dart';
import 'package:blog_frontend/ui/widgets/common/newsPage.dart';
import 'package:blog_frontend/ui/widgets/common/newsToolCard.dart';
import 'package:blog_frontend/ui/widgets/common/userTile.dart';
import 'package:flutter/material.dart';

import 'expandedUserTile.dart';

class NewsScreenPage extends StatelessWidget {
  NewsScreenPage({this.feedBloc, this.usersAndPosts, this.index});

  final NewsFeedBloc feedBloc;
  final List<UiUserEntity> usersAndPosts;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Column(
            children: <Widget>[
              Opacity(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: UserTile(),
                ),
                opacity: 0.0,
              ),
              NewsPage(
                post: usersAndPosts[index].post,
                index: index,
                scrollPosition: feedBloc.scrollPosition,
                createComment: (message, postId) {
                  feedBloc.addPostEvent.add(EventCreateComment(
                      message: message,
                      postId: usersAndPosts[index].post.id));
                },
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 0,
            ),
            child: NewsToolCard(
              index: index,
              scrollPosition: feedBloc.scrollPosition,
              child: ExpandedUserTile(
                currentUserIndex: index,
                newsBloc: feedBloc,
                users: usersAndPosts,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
