import 'package:flutter/material.dart';

class InternalRepositoryUser {
  InternalRepositoryUser({
    @required this.name,
    @required this.password,
    @required this.isAnonymous,
    @required this.imageUrl,
  }) {
    if (name == null && password == null)
      isNotFirstLogin = false;
    else isNotFirstLogin = true;
    InternalRepositoryUser.instance = this;
  }

  static InternalRepositoryUser instance = InternalRepositoryUser(name: '', password: '', isAnonymous: true, imageUrl: '');

  bool isAnonymous;
  bool isNotFirstLogin;
  String name;
  String imageUrl;
  String password;
}
