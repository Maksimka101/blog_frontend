import 'dart:ui';

class LoginEvent {}

class RegisterEvent extends LoginEvent {
  RegisterEvent({
    this.userName,
    this.userPassword,
    this.userAvatar,
  });

  final String userName;
  final String userPassword;
  final Image userAvatar;
}

class AuthenticateEvent extends LoginEvent {
  AuthenticateEvent({
    this.userName,
    this.userPassword,
  });

  final String userName;
  final String userPassword;
}
