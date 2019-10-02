import 'dart:io';

/// class for extends
class LoginEvent {}

class RegisterEvent extends LoginEvent {
  RegisterEvent({
    this.userName,
    this.userPassword,
    this.userAvatar,
  });

  String userName;
  String userPassword;
  File userAvatar;
}

class AuthenticateEvent extends LoginEvent {
  AuthenticateEvent({
    this.userName,
    this.userPassword,
  });

  final String userName;
  final String userPassword;
}

class SignInAnonymousEvent extends LoginEvent {}

/// Don't user it! It is class for extends
class UiEventLogin {}

class UiEventNeedRegister extends UiEventLogin {}

class UiEventRegister extends UiEventLogin {}

class UiEventAuthenticateError extends UiEventLogin {
  UiEventAuthenticateError(this.errorMessage);
  final String errorMessage;
}

class UiEventLoginError extends UiEventLogin {
  UiEventLoginError(this.errorMessage);
  final String errorMessage;
}

class UiEventAuthenticate extends UiEventLogin {}

class UiEventUserIsAuthenticated extends UiEventLogin {}

/// while user loading
class UiEventUserLoading extends UiEventLogin {}
