import 'package:flutter/material.dart';

class InternalRepositoryClient {
  InternalRepositoryClient({
    @required this.name,
    @required this.password,
  }) {
    if (name == null && password == null)
      isRegistered = false;
    else isRegistered = true;
    InternalRepositoryClient.instance = this;
  }

  static InternalRepositoryClient instance;

  bool isRegistered;
  String name;
  String password;
}
