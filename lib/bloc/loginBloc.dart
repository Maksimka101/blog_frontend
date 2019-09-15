import 'dart:async';
import 'package:blog_frontend/bloc/authBloc.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  LoginBloc({@required this.authBloc});
  final AuthBloc authBloc;
  StreamSink<LoginEvent> get authEvents => authBloc.authEvents;

  final _eventStream = PublishSubject<UiEventLogin>();
  Stream<UiEventLogin> get uiEvents => _eventStream.stream;
  StreamSink<UiEventLogin> get addUiEvents => _eventStream.sink;

  dispose() {
    _eventStream.close();
  }
}
