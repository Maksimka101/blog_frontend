import 'package:blog_frontend/ui/entity/uiUserEntity.dart';
import 'package:flutter/material.dart';

class PostEvent {}

class EventLoadPosts extends PostEvent {
  EventLoadPosts({this.userName});
  final String userName;
}

class EventFilterUsers extends PostEvent {
  EventFilterUsers({@required this.showAllUsers, this.userName});
  final bool showAllUsers;
  final String userName;
}

class EventCommentPost extends PostEvent {}


class UiPostEvent {}

class UiEventPosts extends UiPostEvent {
  UiEventPosts({this.usersAndPosts});
  final List<UserUiEntity> usersAndPosts;
}

class UiEventError extends UiPostEvent {
  UiEventError({this.message});
  final String message;
}

class UiEventErrorAndPreviousPosts extends UiPostEvent {
  UiEventErrorAndPreviousPosts({this.message, this.usersAndPosts});
  final String message;
  final List<UserUiEntity> usersAndPosts;
}
