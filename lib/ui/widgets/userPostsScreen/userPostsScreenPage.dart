import 'package:blog_frontend/bloc/userPostsBloc.dart';
import 'package:blog_frontend/events/userPostEvents.dart';
import 'package:blog_frontend/ui/entity/uiPostEntity.dart';
import 'package:blog_frontend/ui/screens/createPostScreen.dart';
import 'package:blog_frontend/ui/widgets/common/newsPage.dart';
import 'package:blog_frontend/ui/widgets/common/newsToolCard.dart';
import 'package:flutter/material.dart';

class UserPostsScreenPage extends StatelessWidget {
  UserPostsScreenPage({
    @required this.userPostsBloc,
    @required this.index,
    @required this.post,
  });

  final int index;
  final UiPostEntity post;
  final UserPostsBloc userPostsBloc;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NewsToolCard(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        userPostsBloc.events.add(EventDeletePost(postId: post.id));
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => CreatePostScreen(previousPost: post,)
                        ));
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.add_circle),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => CreatePostScreen()
                        ));
                      },
                    ),
                  )
                ],
              ),
              scrollPosition: userPostsBloc.scrollPosition,
              index: index,
            ),
          ),
          NewsPage(
            index: index,
            scrollPosition: userPostsBloc.scrollPosition,
            post: post,
            createComment: (message, postId) {

            },
          )
        ],
      ),
    );
  }
}
