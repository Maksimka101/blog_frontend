import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/newsFeedBloc.dart';
import 'package:blog_frontend/events/findUserEvents.dart';
import 'package:blog_frontend/events/newsEvent.dart' as nEvent;
import 'package:blog_frontend/model/response.dart';
import 'package:blog_frontend/model/user.dart';
import 'package:blog_frontend/repository/backendRepository.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:rxdart/rxdart.dart';

class FindUserBloc extends BlocBase {
  FindUserBloc() {
    _findUserEvent.stream.listen(_listenForFindEvent);
  }

  List<User> _users;
  List<String> _subscriptions;

  final _findUserEvent = PublishSubject<FindEvent>();

  StreamSink<FindEvent> get addFindEvents => _findUserEvent.sink;

  final _uiEvents = PublishSubject<FindUiEvent>();

  Stream<FindUiEvent> get uiEvents => _uiEvents.stream;

  void _listenForFindEvent(FindEvent event) {
    switch (event.runtimeType) {
      case EventFindUserByName:
        _findUserByName(event as EventFindUserByName);
        break;
      case EventSubscribeUser:
        _subscribe(event as EventSubscribeUser);
        break;
      case EventUnsubscribeUser:
        _unsubscribe(event as EventUnsubscribeUser);
    }
  }

  void _unsubscribe(EventUnsubscribeUser event) {
    BackendRepository.unsubscribeUser(
            event.name, InternalRepositoryUser.instance.name)
        .then((response) {
      if (response.status == Status.Ok) {
        if (_users != null) {
          if (_subscriptions == null) _subscriptions = <String>[];
          _subscriptions.remove(event.name);
          _uiEvents.sink.add(
              UiEventFoundUsers(subscriptions: _subscriptions, users: _users));
          _updatePosts();
        } else {
          _uiEvents.sink.add(UiEventError(
              errorMessage: 'Что то пошло не так, но отписка прошла успешно.'));
        }
      } else {
        _uiEvents.sink.add(UiEventError(
            errorMessage:
                'Не удалось отписаться. Проверьте подкльчение к интернету'));
      }
    });
  }

  void _subscribe(EventSubscribeUser event) {
    BackendRepository.subscribeUser(
            event.name, InternalRepositoryUser.instance.name)
        .then((response) {
      if (response.status == Status.Ok) {
        if (_users != null) {
          if (_subscriptions == null) _subscriptions = <String>[];
          _subscriptions.add(event.name);
          _uiEvents.sink.add(
              UiEventFoundUsers(subscriptions: _subscriptions, users: _users));
          _updatePosts();
        } else {
          _uiEvents.sink.add(UiEventError(
              errorMessage:
                  'Что то пошло не так, но подписка прошла успешно.'));
        }
      } else {
        _uiEvents.sink.add(UiEventError(
            errorMessage:
                'Не удалось подписаться. Проверьте подкльчение к интернету'));
      }
    });
  }

  void _findUserByName(EventFindUserByName findUserEvent) {
    if (findUserEvent.name.length > 2)
      Future.wait(<Future>[
        BackendRepository.getUsersByName(findUserEvent.name),
        BackendRepository.getUser(InternalRepositoryUser.instance.name)
      ]).then((responses) {
        if (responses.first.status == Status.Ok &&
            responses.last.status == Status.Ok) {
          _subscriptions = responses.last.typedBody.subscriptions;
          _users = responses.first.typedBody.list;
          _users.removeWhere((user) =>
              user.name == InternalRepositoryUser.instance.name.toLowerCase());
          _uiEvents.add(UiEventFoundUsers(
            users: responses.first.typedBody.list,
            subscriptions: responses.last.typedBody.subscriptions,
          ));
        } else {
          _uiEvents.add(UiEventError(
              errorMessage: 'Возможно у вас нет доступа к интернету. '
                  'Попробуйте перезойти и попробовать снова.'));
        }
      });
    else
      _uiEvents.add(null);
  }

  void _updatePosts() {
    BlocProvider.getBloc<NewsFeedBloc>().addPostEvent.add(
        nEvent.EventLoadPosts(userName: InternalRepositoryUser.instance.name));
  }

  void dispose() {
    _uiEvents.close();
    _findUserEvent.close();
    super.dispose();
  }
}
