import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/newsFeedBloc.dart';
import 'package:blog_frontend/events/newsEvent.dart';
import 'package:blog_frontend/model/user.dart';
import 'package:blog_frontend/ui/widgets/expandedUserCard.dart';
import 'package:blog_frontend/ui/widgets/loadingWidget.dart';
import 'package:blog_frontend/ui/widgets/roundedCard.dart';
import 'package:blog_frontend/ui/widgets/userTile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen>
    with AutomaticKeepAliveClientMixin<NewsFeedScreen> {
  final _feedBloc = BlocProvider.getBloc<NewsFeedBloc>();

  final _pageViewController = PageController(viewportFraction: 0.8);

  void _listenPageViewController() {
    _feedBloc.updateScrollPosition.add(_pageViewController.page);
  }

  @override
  void initState() {
    _pageViewController.addListener(_listenPageViewController);
    _feedBloc.addPostEvent.add(EventLoadPosts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UiDataPostEvent>(
      stream: _feedBloc.uiDataPostEvent,
      builder: (context, postsSnapshot) {
        if (postsSnapshot.hasData) {
          final posts = (postsSnapshot.data as UiEventPosts).usersAndPosts;
          posts.add(posts.first);
          return Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // user avatar and name card
                  SizedBox(height: 80,),
                  SizedBox(
                    height: 100,
                    child: PageView.builder(
                      controller: _pageViewController,
                      itemCount: posts.length,
                      itemBuilder: (context, i) {
                        // todo
                        return Container(
                          color: Colors.deepPurple,
                        );
                      },
                    ),
                  )
                ],
              ),
              SingleChildScrollView(
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 35),
                      child: ExpandedUserCard(
                        newsBloc: _feedBloc,
                        users: posts,
                      ),
                    )),
              ),
            ],
          );
        } else
          return LoadingWidget();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
