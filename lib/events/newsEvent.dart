import 'package:blog_frontend/repository/entity/repositoryUserEntity.dart';
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


class UiDataPostEvent {}

class UiEventUsersAndPosts extends UiDataPostEvent {
  UiEventUsersAndPosts({this.usersAndPosts});
  final List<RepositoryUserEntity> usersAndPosts;
}

class UiEventSmallUsersAndPosts extends UiDataPostEvent {
  UiEventSmallUsersAndPosts({@required this.posts});
  final List<UiUserEntity> posts;
}


class UiPostEvent {}

class UiEventError extends UiPostEvent {
  UiEventError({this.message});
  final String message;
}

