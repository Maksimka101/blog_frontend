import 'dart:async';
import 'package:blog_frontend/bloc/authBloc.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:flutter/material.dart';

class LoginBloc {
  LoginBloc({@required this.authBloc});
  final AuthBloc authBloc;
  StreamSink<LoginEvent> get authEvents => authBloc.authEvents;

  Stream<UiEventLogin> get uiEvents => authBloc.uiEvents;
  StreamSink<UiEventLogin> get addUiEvents => authBloc.addUiEvents;
}
