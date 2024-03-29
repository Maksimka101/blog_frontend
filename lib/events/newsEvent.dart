import 'package:blog_frontend/model/user.dart';
import 'package:blog_frontend/ui/entity/uiUserEntity.dart';
import 'package:flutter/material.dart';

abstract class PostEvent {}

class EventLoadPosts extends PostEvent {}

class EventFilterUsers extends PostEvent {
  EventFilterUsers({@required this.showAllUsers, this.userName});
  final bool showAllUsers;
  final String userName;
}

class EventCreateComment extends PostEvent {
  EventCreateComment({this.message, this.postId});
  final String message;
  final int postId;
}

class EventCommentPost extends PostEvent {}

class EventGoToSearchScreen extends PostEvent {}


abstract class UiDataPostEvent {}

class UiEventSmallUsersAndPosts extends UiDataPostEvent {
  UiEventSmallUsersAndPosts({@required this.posts, @required this.users});
  final List<UiUserEntity> posts;
  final List<User> users;
}


abstract class UiPostEvent {}

class UiEventError extends UiPostEvent {
  UiEventError({this.message});
  final String message;
}

