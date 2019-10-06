import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/authBloc.dart';
import 'package:blog_frontend/bloc/loginBloc.dart';
import 'package:blog_frontend/bloc/userPostsBloc.dart';
import 'package:blog_frontend/events/userPostEvents.dart';
import 'package:blog_frontend/model/contants.dart';
import 'package:blog_frontend/ui/screens/createPostScreen.dart';
import 'package:blog_frontend/ui/screens/signin/introductionLoginScreen.dart';
import 'package:blog_frontend/ui/widgets/common/loadingWidget.dart';
import 'package:blog_frontend/ui/widgets/common/roundedCard.dart';
import 'package:blog_frontend/ui/widgets/userPostsScreen/userPostsScreenPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class UserPostsScreen extends StatefulWidget {
  @override
  _UserPostsScreenState createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen>
    with AutomaticKeepAliveClientMixin<UserPostsScreen> {
  final _userPostsBloc = BlocProvider.getBloc<UserPostsBloc>();

  final _pageController = PageController(viewportFraction: 0.85);

  void _listenForPageController() {
    _pageController.addListener(
        () => _userPostsBloc.setScrollPosition.add(_pageController.page));
  }

  @override
  void initState() {
    _listenForPageController();
    _userPostsBloc.events.add(EventLoadPosts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<UserPostsBlocUiEvent>(
      stream: _userPostsBloc.uiEvents,
      builder: (context, postsData) {
        if (postsData.hasData) {
          if (postsData.data.runtimeType == UiEventPosts) {
            final users = (postsData.data as UiEventPosts).users;
            if (users.isNotEmpty)
              return LiquidPullToRefresh(
                  onRefresh: () async {
                    _userPostsBloc.events.add(EventLoadPosts());
                  },
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Colors.white,
                  height: MediaQuery.of(context).size.height * 0.04,
                  showChildOpacityTransition: false,
                  springAnimationDurationInMilliseconds: 400,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height -
                            toolAndAppBarHeight,
                        child: PageView.builder(
                          itemCount: users.length,
                          controller: _pageController,
                          itemBuilder: (context, id) {
                            return UserPostsScreenPage(
                              index: id,
                              post: users[id].post,
                              userPostsBloc: _userPostsBloc,
                            );
                          },
                        ),
                      ),
                    ],
                  ));
            else
              return Center(
                child: RoundedCard(
                    padding: EdgeInsets.all(40),
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Вы ещё не написали ни одного поста.\n'
                              'Сделайте же это.',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 9),
                          child: RaisedButton(
                            child: Text('Создать пост',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CreatePostScreen()));
                            },
                          ),
                        )
                      ],
                    )),
              );
          } else if (postsData.data.runtimeType ==
              UiEventUserIsNotAuthenticated) {
            return Center(
              child: RoundedCard(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                          'Вы не зарегестрированны. Для того, чтобы создавать '
                          'и редактировать посты требуется регистрация.'),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: RaisedButton(
                        child: Text('Авторизоваться'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => IntroductionLoginScreen(
                                  LoginBloc(
                                      authBloc:
                                          BlocProvider.getBloc<AuthBloc>()))));
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          } else
            return Center(
              child: RoundedCard(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Какая то непонятная ошибка...'),
                ),
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
