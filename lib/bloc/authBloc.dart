import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/globalBloc.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:blog_frontend/model/response.dart';
import 'package:blog_frontend/model/user.dart';
import 'package:blog_frontend/repository/backendRepository.dart';
import 'package:blog_frontend/repository/internalRepository.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:blog_frontend/repository/firebaseRepository.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends BlocBase {
  AuthBloc() {
    _internalRepository.loadClient().then((_) {
      var user = _internalRepository.user;
      if (user.isNotFirstLogin) {
        if (!user.isAnonymous)
          BackendRepository.getUser(user.name).then((response) {
            if (response.status == Status.Ok) {
              BlocProvider
                  .getBloc<GlobalBloc>()
                  .setUserStream
                  .add(response.typedBody);
              _uiEventsStream.add(UiEventUserIsAuthenticated());
            }
            else
              _uiEventsStream.add(UiEventAuthenticateError(
                  'Ошибка при загрузке данных с сервера, попробуйте '
                  'перезайти в аккаунт и проверьте подключение к интернету'));
          });
        else
          _uiEventsStream.add(UiEventUserIsAuthenticated());
      } else
        _uiEventsStream.add(UiEventNeedRegister());
    });

    _authEventsStream.listen(_listenEvents);
  }

  final _internalRepository = InternalRepository();

  final _uiEventsStream = BehaviorSubject<UiEventLogin>();

  Stream<UiEventLogin> get uiEvents => _uiEventsStream.stream;
  StreamSink<UiEventLogin> get addUiEvents => _uiEventsStream.sink;

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
        _internalRepository.user = InternalRepositoryUser(
            isAnonymous: false,
            name: authEvent.userName,
            password: authEvent.userPassword);
        _uiEventsStream.add(UiEventUserIsAuthenticated());
      } else {
        // todo
      }
    });
  }

  void _registerWithPassword(RegisterEvent registerEvent) {
    final user = User(
        name: registerEvent.userName,
        imageUrl: FirebaseRepository.saveUserImage(registerEvent.userAvatar));
    final cacheUser = InternalRepositoryUser(
        isAnonymous: false,
        password: registerEvent.userPassword,
        name: registerEvent.userName);
    _internalRepository.user = cacheUser;
    BackendRepository.registerUser(user);
    _uiEventsStream.add(UiEventUserIsAuthenticated());
  }

  @override
  void dispose() {
    _uiEventsStream.close();
    _authEventsStream.close();
    super.dispose();
  }
}
