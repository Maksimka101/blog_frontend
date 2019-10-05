import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/events/userPostEvents.dart';
import 'package:blog_frontend/model/comment.dart';
import 'package:blog_frontend/model/response.dart';
import 'package:blog_frontend/repository/backendRepository.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:blog_frontend/repository/entity/repositoryUserEntity.dart';
import 'package:connectivity/connectivity.dart';
import 'package:rxdart/rxdart.dart';

class UserPostsBloc extends BlocBase {
  UserPostsBloc() {
    _eventsStream.stream.listen(_listenForEvents);
  }

  final _userName = InternalRepositoryUser.instance.name;

  final _errorUiEvents = StreamController<UiEventError>.broadcast();
  Stream<UiEventError> get errorUiEvents => _errorUiEvents.stream;

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
      case EventCreateComment:
        _createComment(event as EventCreateComment);
        break;
    }
  }

  void _loadUserPosts(EventLoadPosts event) async {
    if (InternalRepositoryUser.instance.isAnonymous)
      _uiEventStream.add(UiEventUserIsNotAuthenticated());
    else {
      if (await _isNotConnected()) return;
    BackendRepository.getUserWithPosts(_userName).then((response) {
        if (response.status == Status.Ok) {
          _uiEventStream.add(UiEventPosts(
              users: RepositoryUserEntity.convertForUiAndSort(
                  <RepositoryUserEntity>[response.typedBody])));
        } else {
          _errorUiEvents.add(UiEventError(
              message:
              'Не удалось загрузить посты.'));
        }
      });
    }
  }

  void _createComment(EventCreateComment event) async {
    if (await _isNotConnected()) return;
    if (event.content.trim().isEmpty) return;
    BackendRepository.createComment(Comment(
            authorId: _userName,
            authorImageUrl: InternalRepositoryUser.instance.imageUrl,
            content: event.content,
            postId: event.postId))
        .then((response) {
      if (response.status != Status.Ok) {
        _loadUserPosts(EventLoadPosts(userName: _userName));
        _errorUiEvents.sink
            .add(UiEventError(message: 'Не удалось создать комментарий.'));
      } else {
        _eventsStream.add(EventLoadPosts(userName: _userName));
      }
    });
  }

  void _deletePost(EventDeletePost event) async {
    if (await _isNotConnected()) return;
    BackendRepository.deletePost(event.postId).then((response) {
      if (response.status != Status.Ok) {
        _errorUiEvents.sink
            .add(UiEventError(message: 'Не удалось удалить пост.'));
      } else {
        _eventsStream.add(EventLoadPosts(userName: _userName));
      }
    });
  }

  Future<bool> _isNotConnected() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      _errorUiEvents.add(UiEventError(message: 'Нет подключения к интернету.'));
      return true;
    } else return false;
  }

  @override
  void dispose() {
    _scrollPosition.close();
    _eventsStream.close();
    _uiEventStream.close();
    _errorUiEvents.close();
    super.dispose();
  }
}
