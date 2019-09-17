import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/events/newsEvent.dart';
import 'package:blog_frontend/model/response.dart';
import 'package:blog_frontend/repository/backendRepository.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:blog_frontend/ui/entity/uiUserEntity.dart';
import 'package:rxdart/rxdart.dart';

class NewsFeedBloc extends BlocBase {
  NewsFeedBloc() {
    _postEvents.stream.listen(_listenPostEvent);
  }

  List<UserUiEntity> _previousPosts;

  void _listenPostEvent(PostEvent event) {
    switch (event.runtimeType) {
      case EventLoadPosts:
        _loadUserSubscriptions(InternalRepositoryUser.instance.name);
        break;
      case EventFilterUsers:
        _filterUsers(event as EventFilterUsers);
        break;
    }
  }

  void _filterUsers(EventFilterUsers event) {
    if (event.showAllUsers)
      _uiPostEvent.add(UiEventPosts(usersAndPosts: _previousPosts));
    else {
      _uiPostEvent.add(UiEventPosts(usersAndPosts: <UserUiEntity>[
        _previousPosts.where((user) => user.name == event.userName).first
      ]));
    }
  }

  void _loadUserSubscriptions(String userName) {
    BackendRepository.getAllUserSubscription(userName).then((usersResponse) {
      if (usersResponse.status == Status.Ok) {
        _uiPostEvent
            .add(UiEventPosts(usersAndPosts: usersResponse.typedBody.list));
        _previousPosts = usersResponse.typedBody.list;
      } else {
        if (_previousPosts != null)
          _uiPostEvent.add(UiEventErrorAndPreviousPosts(
              usersAndPosts: _previousPosts,
              message: 'Ошибка при загрузки с сервера. Проверьте подключение '
                  'к интернету или попробуйте перезайти.'));
        else
          _uiPostEvent.add(UiEventError(
              message: 'Ошибка при загрузки с сервера. Проверьте подключение '
                  'к интернету или попробуйте перезайти.'));
      }
    });
  }

  final _postEvents = PublishSubject<PostEvent>();

//  Stream<PostEvent> get postEvent => _postEvents.stream;
  StreamSink<PostEvent> get addPostEvent => _postEvents.sink;

  final _uiPostEvent = PublishSubject<UiPostEvent>();

  Stream<UiPostEvent> get uiPostEvent => _uiPostEvent.stream;

  void dispose() {
    _postEvents.close();
    _uiPostEvent.close();
  }
}