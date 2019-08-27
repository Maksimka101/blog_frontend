import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/globalBloc.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:blog_frontend/model/user.dart';
import 'package:blog_frontend/repository/backendRepository.dart';
import 'package:blog_frontend/repository/cacheRepository.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends BlocBase {
  AuthBloc({this.globalBloc}) {
    _userStream.stream.listen((user) => globalBloc.setUserStream.add(user));
    _cacheRepository.getUser().then((user) => _userStream.sink.add(user));
  }

  final GlobalBloc globalBloc;
  final _cacheRepository = CacheRepository();

  final _userStream = PublishSubject<User>();
  Stream<User> get userStream => _userStream.stream;

  final _authEvents = PublishSubject<LoginEvent>();
  Stream<LoginEvent> get authEvents => _authEvents.stream;

  void _listenEvents(LoginEvent event) {

  }

  // todo
  void registerUserByLoginAndPassword(String userName, String userPassword) {
    final user = User(
      name: userName,
      password: userPassword,
    );
    BackendRepository.registerUser(user);
  }

  @override
  void dispose() {
    _userStream.close();
    _authEvents.close();
    super.dispose();
  }
}
