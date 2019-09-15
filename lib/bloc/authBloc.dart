import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/globalBloc.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:blog_frontend/model/response.dart';
import 'package:blog_frontend/model/user.dart';
import 'package:blog_frontend/repository/backendRepository.dart';
import 'package:blog_frontend/repository/cacheRepository.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:blog_frontend/repository/firebaseRepository.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends BlocBase {
  AuthBloc() {
    globalBloc = BlocProvider.getBloc<GlobalBloc>();
    var client = _internalRepository.client;
    if (client.isRegistered)
      BackendRepository.getUser(client.name).then((userInResponse) =>
          globalBloc.setUserStream.add(userInResponse.typedBody));
    _authEventsStream.listen(_listenEvents);
  }

  GlobalBloc globalBloc;
  final _internalRepository = InternalRepository();

  final _uiEventsStream = PublishSubject<UiEventLogin>();

  Stream<UiEventLogin> get uiEvents => _uiEventsStream.stream;

  final _authEventsStream = PublishSubject<LoginEvent>();

  StreamSink<LoginEvent> get authEvents => _authEventsStream.sink;

  void _listenEvents(LoginEvent event) {
    switch (event.runtimeType) {
      case RegisterEvent:
        _registerWithPassword(event as RegisterEvent);
        break;
      case AuthenticateEvent:
        _authenticateUserByPassword(event as AuthenticateEvent);
        break;
    }
  }

  void _authenticateUserByPassword(AuthenticateEvent authEvent) {
    BackendRepository.getUser(authEvent.userName).then((response) {
      if (response.status == Status.Ok) {
        _internalRepository.client = InternalRepositoryClient(
            name: authEvent.userName, password: authEvent.userPassword);
        _uiEventsStream.add(UiEventUserAuthenticated());
      } else {
        // todo
      }
    });
  }

  void _registerWithPassword(RegisterEvent registerEvent) {
    final user = User(
        name: registerEvent.userName,
        imageUrl: FirebaseRepository.saveUserImage(registerEvent.userAvatar));
    final cacheUser = InternalRepositoryClient(
        password: registerEvent.userPassword, name: registerEvent.userName);
    _internalRepository.client = cacheUser;
    BackendRepository.registerUser(user);
    _uiEventsStream.add(UiEventUserAuthenticated());
  }

  @override
  void dispose() {
    _uiEventsStream.close();
    _authEventsStream.close();
    super.dispose();
  }
}
