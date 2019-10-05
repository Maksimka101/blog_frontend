import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:blog_frontend/model/response.dart';
import 'package:blog_frontend/model/user.dart';
import 'package:blog_frontend/repository/backendRepository.dart';
import 'package:blog_frontend/repository/internalRepository.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:blog_frontend/repository/firebaseRepository.dart';
import 'package:connectivity/connectivity.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends BlocBase {
  AuthBloc() {
    _initLoad();

    _authEventsStream.listen(_listenEvents);
  }

  void _initLoad() {
    _internalRepository.loadUser().then((_) async {
      var user = InternalRepositoryUser.instance;
      if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
        _uiEventsStream.add(
            UiEventLoadAuthorizedUserError('Нет подключения к интернету.'));
        return;
      }
      if (user.isNotFirstLogin) {
        if (!user.isAnonymous)
          BackendRepository.getUser(user.name).then((response) {
            if (response.status == Status.Ok) {
              _uiEventsStream.add(UiEventUserIsAuthenticated());
            } else {
              _uiEventsStream.add(UiEventNeedRegister());
            }
          });
        else
          _uiEventsStream.add(UiEventUserIsAuthenticated());
      } else
        _uiEventsStream.add(UiEventNeedRegister());
    });
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
      case SignInAnonymousEvent:
        _signInAnonymous();
        break;
    }
  }

  void _signInAnonymous() {
    _internalRepository.user = InternalRepositoryUser(
      isAnonymous: true,
      password: '',
      name: '',
      imageUrl: '',
    );
    _uiEventsStream.add(UiEventUserIsAuthenticated());
  }

  void _authenticateUserByPassword(AuthenticateEvent authEvent) async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      _uiEventsStream
          .add(UiEventAuthenticateError('Нет подключения к интернету.'));
      return;
    }
    BackendRepository.getUser(authEvent.userName).then((response) {
      if (response.status == Status.Ok) {
        _internalRepository.user = InternalRepositoryUser(
            imageUrl: response.typedBody.imageUrl,
            isAnonymous: false,
            name: authEvent.userName,
            password: authEvent.userPassword);
        _uiEventsStream.add(UiEventUserIsAuthenticated());
      } else {
        print(response.body);
        _uiEventsStream.add(UiEventAuthenticateError(
            'Ошибка на сервере. Возможно вы ввели не верные данные, '
            'еще не зарегестрировались.'));
      }
    });
  }

  void _registerWithPassword(RegisterEvent registerEvent) async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      _uiEventsStream.add(UiEventLoginError('Нет подключения к интернету.'));
      return;
    }
    _uiEventsStream.add(UiEventLoading());
    final imageUrl =
        await FirebaseRepository.saveImage(registerEvent.userAvatar);
    final user = User(name: registerEvent.userName, imageUrl: imageUrl);
    final resp =
        await BackendRepository.registerUser(user, registerEvent.userPassword);
    if (resp.status != Status.Ok)
      _uiEventsStream.add(UiEventLoginError('Ошибка при регистрации. '
          'Попробуйте выбрать другое имя.'));
    else {
      final internalUser = InternalRepositoryUser(
          imageUrl: imageUrl,
          isAnonymous: false,
          password: registerEvent.userPassword,
          name: registerEvent.userName);
      InternalRepository().user = internalUser;
      _uiEventsStream.add(UiEventUserIsAuthenticated());
    }
  }

  @override
  void dispose() {
    _uiEventsStream.close();
    _authEventsStream.close();
    super.dispose();
  }
}
