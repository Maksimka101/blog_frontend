import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/newsFeedBloc.dart';
import 'package:blog_frontend/events/newsEvent.dart';
import 'package:blog_frontend/model/contants.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:blog_frontend/ui/widgets/common/loadingWidget.dart';
import 'package:blog_frontend/ui/widgets/newsScreen/newsScreenPage.dart';
import 'package:flutter/material.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen>
    with AutomaticKeepAliveClientMixin<NewsFeedScreen> {
  final _feedBloc = BlocProvider.getBloc<NewsFeedBloc>();

  final _pageViewController = PageController(viewportFraction: 0.85);

  void _listenPageViewController() {
    _feedBloc.updateScrollPosition.add(_pageViewController.page);
  }

  @override
  void initState() {
    _pageViewController.addListener(_listenPageViewController);
    _feedBloc.addPostEvent
        .add(EventLoadPosts(userName: InternalRepositoryUser.instance.name));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UiDataPostEvent>(
      stream: _feedBloc.uiDataPostEvent,
      builder: (context, postsSnapshot) {
        if (postsSnapshot.hasData) {
          final usersAndPosts =
              (postsSnapshot.data as UiEventSmallUsersAndPosts).posts;
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height - toolAndAppBarHeight,
                  child: PageView.builder(
                    controller: _pageViewController,
                    itemCount: usersAndPosts.length,
                    itemBuilder: (context, i) {
                      return NewsScreenPage(
                        usersAndPosts: usersAndPosts,
                        feedBloc: _feedBloc,
                        index: i,
                      );
                    },
                  ),
                )
              ],
            ),
          );
        } else
          return LoadingWidget();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
