import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/newsFeedBloc.dart';
import 'package:blog_frontend/events/newsEvent.dart';
import 'package:blog_frontend/ui/widgets/loadingWidget.dart';
import 'package:flutter/material.dart';

class NewsFeedScreen extends StatelessWidget {
  final _feedBloc = BlocProvider.getBloc<NewsFeedBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UiDataPostEvent>(
      stream: _feedBloc.uiDataPostEvent,
      builder: (context, postsSnapshot) {
        if (postsSnapshot.hasData) {
          final posts = (postsSnapshot.data as UiEventPosts).usersAndPosts;
          return Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // user avatar and name card
                  Card(),
                  PageView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, i) {
                      // todo
                      return Container();
                    },
                  )
                ],
              ),
              // users for choose
              Card()
            ],
          );
        } else
          return LoadingWidget();
      },
    );
  }
}
