import 'package:blog_frontend/model/comment.dart';
import 'package:blog_frontend/ui/widgets/common/commentTile.dart';
import 'package:blog_frontend/ui/widgets/common/roundedCard.dart';
import 'package:flutter/material.dart';

class CommentsWidget extends StatefulWidget {
  CommentsWidget({this.onSend, this.comments});

  final List<Comment> comments;
  final void Function(String message) onSend;

  @override
  _CommentsWidgetState createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  final _textEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          RoundedCard(
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textEditController,
                      decoration: InputDecoration(
                        hintText: 'Ваш комментарий',
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      widget.onSend(_textEditController.text);
                      _textEditController.clear();
                    },
                  )
                ],
              ),
            ),
          ),
          for (final comment in widget.comments)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: CommentTile(
                imageUrl: comment.authorImageUrl,
                content: comment.content,
                authorName: comment.authorId,
              ),
            ),
        ],
      ),
    );
  }
}
