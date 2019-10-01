import 'package:blog_frontend/model/post.dart';
import 'package:blog_frontend/repository/entity/repositoryUserEntity.dart';
import 'package:blog_frontend/ui/entity/uiUserEntity.dart';

class UserPostsBlocEvent {}

class EventLoadPosts extends UserPostsBlocEvent {
  EventLoadPosts({this.userName});
  final String userName;
}

class EventDeletePost extends UserPostsBlocEvent {
  EventDeletePost({this.postId});
  final int postId;
}

class EventCreatePost extends UserPostsBlocEvent {
  EventCreatePost({this.post});
  final Post post;
}


class UserPostsBlocUiEvent {}

class UiEventPosts extends UserPostsBlocUiEvent {
  UiEventPosts({this.users});
  final List<UiUserEntity> users;
}

class UiEventError extends UserPostsBlocUiEvent {
  UiEventError({this.message});
  final String message;
}
