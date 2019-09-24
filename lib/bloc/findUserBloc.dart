import 'dart:async';
import 'package:blog_frontend/events/findUserEvents.dart';
import 'package:blog_frontend/model/response.dart';
import 'package:blog_frontend/repository/backendRepository.dart';
import 'package:rxdart/rxdart.dart';

class FindUserBloc {
  FindUserBloc() {
    _findUserEvent.stream.listen(_listenForFindEvent);
  }

  final _findUserEvent = PublishSubject<FindEvent>();
  StreamSink<FindEvent> get addFindEvents => _findUserEvent.sink;
  
  final _uiEvents = PublishSubject<FindUiEvent>();
  Stream<FindUiEvent> get uiEvents => _uiEvents.stream;

  void _listenForFindEvent(FindEvent event) {
    switch (event.runtimeType) {
      case EventFindUserByName:
        _findUserByName(event as EventFindUserByName);
        break;
    }
  }

  void _findUserByName(EventFindUserByName findUserEvent) {
    BackendRepository.getUsersByName(findUserEvent.name).then((response) {
      if (response.status == Status.Ok) {
        _uiEvents.add(UiEventFoundUsers(users: response.typedBody.list));
      } else {
        _uiEvents.add(UiEventError(
          errorMessage: 'Возможно у вас нет доступа к интернету. '
              'Попробуйте перезойти и попробовать снова.'
        ));
      }
    });
  }

  void dispose() {
    _uiEvents.close();
    _findUserEvent.close();
  }
}