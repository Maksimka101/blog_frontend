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
      _uiDataPostEvent.add(UiEventPosts(usersAndPosts: _previousPosts));
    else {
      _uiDataPostEvent.add(UiEventPosts(usersAndPosts: <UserUiEntity>[
        _previousPosts.where((user) => user.name == event.userName).first
      ]));
    }
  }

  void _loadUserSubscriptions(String userName) {
    BackendRepository.getAllUserSubscription(userName).then((usersResponse) {
      if (usersResponse.status == Status.Ok) {
        _uiDataPostEvent
            .add(UiEventPosts(usersAndPosts: usersResponse.typedBody.list));
        _previousPosts = usersResponse.typedBody.list;
      } else {
        _uiPostEvent.add(UiEventError(
            message: 'Ошибка при загрузки с сервера. Проверьте подключение '
                'к интернету или попробуйте перезайти.'));
      }
    });
  }

  List<UserUiEntity> _previousPosts;



  final _postEvents = PublishSubject<PostEvent>();

//  Stream<PostEvent> get postEvent => _postEvents.stream;
  StreamSink<PostEvent> get addPostEvent => _postEvents.sink;

  final _uiPostEvent = PublishSubject<UiPostEvent>();
  
  Stream<UiPostEvent> get uiPostEvent => _uiPostEvent.stream;
  StreamSink<UiPostEvent> get addUiPostEvent => _uiPostEvent.sink;

  final _uiDataPostEvent = PublishSubject<UiDataPostEvent>();

  Stream<UiDataPostEvent> get uiDataPostEvent => _uiDataPostEvent.stream;

  void dispose() {
    _postEvents.close();
    _uiDataPostEvent.close();
    super.dispose();
  }
}
