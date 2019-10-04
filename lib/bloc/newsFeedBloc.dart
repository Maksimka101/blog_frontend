import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/events/newsEvent.dart';
import 'package:blog_frontend/model/comment.dart';
import 'package:blog_frontend/model/response.dart';
import 'package:blog_frontend/model/user.dart';
import 'package:blog_frontend/repository/backendRepository.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:blog_frontend/repository/entity/repositoryUserEntity.dart';
import 'package:connectivity/connectivity.dart';
import 'package:rxdart/rxdart.dart';

import 'mainAppScreenBloc.dart';

class NewsFeedBloc extends BlocBase {
  NewsFeedBloc() {
    BlocProvider.getBloc<MainAppScreenBloc>().page.listen(_listenForPages);
    _postEvents.stream.listen(_listenPostEvent);
  }

  void _listenPostEvent(PostEvent event) {
    switch (event.runtimeType) {
      case EventLoadPosts:
        _loadUserSubscriptions(event as EventLoadPosts);
        break;
      case EventFilterUsers:
        _filterUsers(event as EventFilterUsers);
        break;
      case EventCreateComment:
        _createComment(event as EventCreateComment);
        break;
    }
  }

  void _listenForPages(int pageIndex) {
    if (pageIndex == 0)
      _loadUserSubscriptions(EventLoadPosts(userName: _userName));
  }

  void _filterUsers(EventFilterUsers event) {
    if (event.showAllUsers)
      _uiDataPostEvent.add(UiEventSmallUsersAndPosts(
          users: _previousPosts.map((user) => user.user).toList(),
          posts: RepositoryUserEntity.convertForUiAndSort(_previousPosts)));
    else {
      _uiDataPostEvent.add(UiEventSmallUsersAndPosts(
          users: <User>[
            _previousPosts
                .reduce((user1, user2) =>
                    user1.user.name == event.userName ? user1 : user2)
                .user
          ],
          posts: RepositoryUserEntity.convertForUiAndSort(_previousPosts)
            ..removeWhere((user) => user.user.name != event.userName)));
    }
  }

  void _loadUserSubscriptions(EventLoadPosts event) async {
    if (await _isNotConnected()) return;
    BackendRepository.getAllUserSubscription(event.userName)
        .then((usersResponse) {
      if (usersResponse.status == Status.Ok) {
        _uiDataPostEvent.add(UiEventSmallUsersAndPosts(
            users:
                usersResponse.typedBody.list.map((user) => user.user).toList(),
            posts: RepositoryUserEntity.convertForUiAndSort(
                usersResponse.typedBody.list)));
        _previousPosts = usersResponse.typedBody.list;
      } else {
        _uiPostEvent.add(UiEventError(
            message: 'Ошибка при загрузки с сервера. Проверьте подключение '
                'к интернету или попробуйте перезайти.'));
      }
    });
  }

  void _createComment(EventCreateComment event) async {
    if (event.message.trim().isEmpty) return;
    if (await _isNotConnected()) return;
    final comment = Comment(
        content: event.message, postId: event.postId, authorId: _userName);
    BackendRepository.createComment(comment).then((response) {
      if (response.status != Status.Ok) {
        _uiPostEvent.sink
            .add(UiEventError(message: 'Не удалось создать пост.'));
        _loadUserSubscriptions(EventLoadPosts(userName: _userName));
      }
    });
  }

  Future<bool> _isNotConnected() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      _uiPostEvent.add(UiEventError(message: 'Нет подключения к интернету.'));
      return true;
    } else
      return false;
  }

  final _userName = InternalRepositoryUser.instance.name;

  List<RepositoryUserEntity> _previousPosts;

  final _scrollPositionScream = PublishSubject<double>();

  Stream<double> get scrollPosition => _scrollPositionScream.stream;

  StreamSink<double> get updateScrollPosition => _scrollPositionScream.sink;

  final _postEvents = PublishSubject<PostEvent>();

  StreamSink<PostEvent> get addPostEvent => _postEvents.sink;

  final _uiPostEvent = PublishSubject<UiPostEvent>();

  Stream<UiPostEvent> get uiPostEvent => _uiPostEvent.stream;

  StreamSink<UiPostEvent> get addUiPostEvent => _uiPostEvent.sink;

  final _uiDataPostEvent = PublishSubject<UiDataPostEvent>();

  Stream<UiDataPostEvent> get uiDataPostEvent => _uiDataPostEvent.stream;

  void dispose() {
    _postEvents.close();
    _uiDataPostEvent.close();
    _scrollPositionScream.close();
    super.dispose();
  }
}
