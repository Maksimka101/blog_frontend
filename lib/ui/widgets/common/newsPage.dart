import 'package:blog_frontend/model/comment.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:blog_frontend/ui/entity/uiPostEntity.dart';
import 'package:blog_frontend/ui/widgets/common/animatedNewsCard.dart';
import 'package:flutter/material.dart';

import 'commentsWidget.dart';

class NewsPage extends StatefulWidget {
  NewsPage(
      {@required this.index,
      @required this.post,
      @required this.createComment,
      @required this.scrollPosition});

  final Stream<double> scrollPosition;
  final int index;
  final UiPostEntity post;
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
        AnimatedNewsCard(
          scrollPosition: widget.scrollPosition,
          post: widget.post,
          currentPostIndex: widget.index,
          onExpanded: (expanded) => setState(() => _isExpanded = expanded),
        ),
        if (_isExpanded)
          CommentsWidget(
              comments: widget.post.comments,
              onSend: (message) => setState(() {
                    widget.createComment(
                        message, widget.post.id);
                    // сделано через одно место
                    widget.post.comments
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
