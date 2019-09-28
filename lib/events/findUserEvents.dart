import 'package:blog_frontend/model/user.dart';

class FindEvent {}

class EventFindUserByName extends FindEvent {
  EventFindUserByName({this.name});
  final String name;
}

class EventSubscribeUser extends FindEvent {
  EventSubscribeUser({this.name});
  final String name;
}

class EventUnsubscribeUser extends FindEvent {
  EventUnsubscribeUser({this.name});
  final String name;
}


class FindUiEvent {}

class UiEventFoundUsers extends FindUiEvent {
  UiEventFoundUsers({this.users, this.subscriptions});
  final List<String> subscriptions;
  final List<User> users;
}

class UiEventError extends FindUiEvent {
  UiEventError({this.errorMessage});
  final String errorMessage;
}
