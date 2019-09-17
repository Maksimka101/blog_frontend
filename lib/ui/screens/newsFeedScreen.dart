import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/newsFeedBloc.dart';
import 'package:blog_frontend/events/newsEvent.dart';
import 'package:blog_frontend/ui/widgets/loadingWidget.dart';
import 'package:flutter/material.dart';

class NewsFeedScreen extends StatelessWidget {
  final _feedBloc = BlocProvider.getBloc<NewsFeedBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UiPostEvent>(
      stream: _feedBloc.uiPostEvent,
      builder: (context, postsSnapshot) {
        if (postsSnapshot.hasData) {
          return Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // user avatar and name card
                  Card()
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
