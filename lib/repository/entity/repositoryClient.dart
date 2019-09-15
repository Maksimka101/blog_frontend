import 'package:flutter/material.dart';

class InternalRepositoryUser {
  InternalRepositoryUser({
    @required this.name,
    @required this.password,
    @required this.isAnonymous
  }) {
    if (name == null && password == null && isAnonymous == null)
      isRegistered = false;
    else isRegistered = true;
    InternalRepositoryUser.instance = this;
  }

  static InternalRepositoryUser instance = InternalRepositoryUser(name: '', password: '', isAnonymous: true);

  bool isAnonymous;
  bool isRegistered;
  String name;
  String password;
}
