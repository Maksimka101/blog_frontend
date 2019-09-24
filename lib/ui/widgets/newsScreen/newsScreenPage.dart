import 'package:blog_frontend/bloc/newsFeedBloc.dart';
import 'package:blog_frontend/events/newsEvent.dart';
import 'package:blog_frontend/model/comment.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:blog_frontend/ui/entity/uiUserEntity.dart';
import 'package:blog_frontend/ui/widgets/common/commentsWidget.dart';
import 'package:blog_frontend/ui/widgets/common/userTile.dart';
import 'package:flutter/material.dart';

import 'expandedUserCard.dart';
import 'newsCard.dart';

class NewsScreenPage extends StatefulWidget {
  NewsScreenPage({this.feedBloc, this.usersAndPosts, this.index});

  final NewsFeedBloc feedBloc;
  final List<UiUserEntity> usersAndPosts;
  final int index;

  @override
  _NewsScreenPageState createState() => _NewsScreenPageState();
}

class _NewsScreenPageState extends State<NewsScreenPage> {
  var _isExpanded = false;

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
              NewsScreenNewsCard(
                scrollPosition: widget.feedBloc.scrollPosition,
                post: widget.usersAndPosts[widget.index].post,
                currentPostIndex: widget.index,
                onExpanded: (expanded) =>
                    setState(() => _isExpanded = expanded),
              ),
              if (_isExpanded)
                CommentsWidget(
                    comments: widget.usersAndPosts[widget.index].post.comments,
                    onSend: (message) => setState(() {
                          widget.feedBloc.addPostEvent.add(EventCreateComment(
                              message: message,
                              postId:
                                  widget.usersAndPosts[widget.index].post.id));
                          // сделано через одно место
                          widget.usersAndPosts[widget.index].post.comments.add(Comment(
                            authorId: InternalRepositoryUser.instance.name,
                            content: message,
                            postId: widget.index,
                            authorImageUrl: InternalRepositoryUser.instance.imageUrl,
                          ));
                        }))
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 0,
            ),
            child: ExpandedUserCard(
              currentUserIndex: widget.index,
              newsBloc: widget.feedBloc,
              users: widget.usersAndPosts,
            ),
          ),
        ],
      ),
    );
  }
}
