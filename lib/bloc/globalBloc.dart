import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/model/user.dart';
import 'package:rxdart/rxdart.dart';

class GlobalBloc extends BlocBase {
  GlobalBloc();

  final _userStream = BehaviorSubject<User>();
  Stream<User> get getUserStream => _userStream.stream;
  StreamSink<User> get setUserStream => _userStream.sink;

//  final _subscribes = BehaviorSubject<List<User>>();
//  Stream<List<User>> get getSubscribesStream => _subscribes.stream;
//  StreamSink<List<User>> get strSubscribesStream => _subscribes.sink;

  @override
  void dispose() {
    _userStream.close();
    super.dispose();
//    _subscribes.close();
  }
}