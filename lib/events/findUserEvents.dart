import 'package:blog_frontend/model/user.dart';

class FindEvent {}

class EventFindUserByName extends FindEvent {
  EventFindUserByName({this.name});
  final String name;
}

class FindUiEvent {}

class UiEventFoundUsers extends FindUiEvent {
  UiEventFoundUsers({this.users});
  final List<User> users;
}

class UiEventError extends FindUiEvent {
  UiEventError({this.errorMessage});
  final String errorMessage;
}
