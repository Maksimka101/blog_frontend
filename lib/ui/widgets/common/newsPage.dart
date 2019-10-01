import 'package:blog_frontend/model/comment.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:blog_frontend/ui/entity/uiUserEntity.dart';
import 'package:blog_frontend/ui/widgets/newsScreen/newsCard.dart';
import 'package:flutter/material.dart';

import 'commentsWidget.dart';

class NewsPage extends StatefulWidget {
  NewsPage(
      {@required this.index,
      @required this.usersAndPosts,
      @required this.createComment,
      @required this.scrollPosition});

  final Stream<double> scrollPosition;
  final int index;
  final List<UiUserEntity> usersAndPosts;
  final void Function(String message, int postId) createComment;

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NewsScreenNewsCard(
          scrollPosition: widget.scrollPosition,
          post: widget.usersAndPosts[widget.index].post,
          currentPostIndex: widget.index,
          onExpanded: (expanded) => setState(() => _isExpanded = expanded),
        ),
        if (_isExpanded)
          CommentsWidget(
              comments: widget.usersAndPosts[widget.index].post.comments,
              onSend: (message) => setState(() {
                    widget.createComment(
                        message, widget.usersAndPosts[widget.index].post.id);
                    // сделано через одно место
                    widget.usersAndPosts[widget.index].post.comments
                        .add(Comment(
                      authorId: InternalRepositoryUser.instance.name,
                      content: message,
                      postId: widget.index,
                      authorImageUrl: InternalRepositoryUser.instance.imageUrl,
                    ));
                  }))
      ],
    );
  }
}
