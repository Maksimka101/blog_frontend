import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/events/userPostEvents.dart';
import 'package:blog_frontend/model/response.dart';
import 'package:blog_frontend/repository/backendRepository.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:blog_frontend/repository/entity/repositoryUserEntity.dart';
import 'package:rxdart/rxdart.dart';

class UserPostsBloc extends BlocBase {
  UserPostsBloc() {
    _eventsStream.stream.listen(_listenForEvents);
  }

  final _scrollPosition = StreamController<double>.broadcast();

  Stream<double> get scrollPosition => _scrollPosition.stream;

  StreamSink<double> get setScrollPosition => _scrollPosition.sink;

  final _eventsStream = PublishSubject<UserPostsBlocEvent>();

  StreamSink<UserPostsBlocEvent> get events => _eventsStream.sink;

  final _uiEventStream = PublishSubject<UserPostsBlocUiEvent>();

  Stream<UserPostsBlocUiEvent> get uiEvents => _uiEventStream.stream;

  void _listenForEvents(UserPostsBlocEvent event) {
    switch (event.runtimeType) {
      case EventLoadPosts:
        _loadUserPosts(event as EventLoadPosts);
        break;
      case EventDeletePost:
        _deletePost(event as EventDeletePost);
        break;
    }
  }

  void _loadUserPosts(EventLoadPosts event) {
    if (InternalRepositoryUser.instance.isAnonymous)
      _uiEventStream.add(UiEventUserIsNotAuthenticated());
    else
      BackendRepository.getUserWithPosts(InternalRepositoryUser.instance.name)
          .then((response) {
        if (response.status == Status.Ok) {
          _uiEventStream.add(UiEventPosts(
              users: RepositoryUserEntity.convertForUiAndSort(
                  <RepositoryUserEntity>[response.typedBody])));
        } else {
          _uiEventStream.add(UiEventError(
              message:
                  'Не удалось загрузить посты. Проверьте подключение к интернету.'));
        }
      });
  }

  void _deletePost(EventDeletePost event) {
    BackendRepository.deletePost(event.postId).then((response) {
      if (response.status != Status.Ok) {
        _uiEventStream.sink.add(UiEventError(
            message: 'Не удалось удалить пост. '
                'Проверьте подключение к интернету и попробуйте перезайти.'));
      }
    });
  }

  @override
  void dispose() {
    _scrollPosition.close();
    _eventsStream.close();
    _uiEventStream.close();
    super.dispose();
  }
}