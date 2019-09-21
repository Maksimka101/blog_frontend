import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/newsFeedBloc.dart';
import 'package:blog_frontend/events/newsEvent.dart';
import 'package:blog_frontend/model/contants.dart';
import 'package:blog_frontend/ui/entity/uiPostEntity.dart';
import 'package:blog_frontend/ui/widgets/common/newsCard.dart';
import 'package:blog_frontend/ui/widgets/newsScreen/expandedUserCard.dart';
import 'package:blog_frontend/ui/widgets/common/loadingWidget.dart';
import 'package:flutter/material.dart';

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
          final users = (postsSnapshot.data as UiEventPosts).usersAndPosts;
          final pl = users.length;
          for (int i = 0; i < pl; i++) users.add(users[i]);
          final posts = <UiPostEntity>[];
          users.forEach((user) => user.posts.forEach((post) => posts.add(post)));
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height-toolAndAppBarHeight,
                child: PageView.builder(
                  controller: _pageViewController,
                  itemCount: posts.length,
                  itemBuilder: (context, i) {
                    return Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(height: 75,),
                            NewsCard(
                              scrollPosition: _feedBloc.scrollPosition,
                              post: posts[i],
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, ),
                          child: ExpandedUserCard(
                            currentUserIndex: i,
                            newsBloc: _feedBloc,
                            users: users,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
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
