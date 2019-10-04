import 'package:blog_frontend/model/post.dart';
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

class EventCreateComment extends UserPostsBlocEvent {
  EventCreateComment({this.content, this.postId});
  final int postId;
  final String content;
}


class UserPostsBlocUiEvent {}

class UiEventPosts extends UserPostsBlocUiEvent {
  UiEventPosts({this.users});
  final List<UiUserEntity> users;
}

class UiEventUserIsNotAuthenticated extends UserPostsBlocUiEvent {}

class UiEventError {
  UiEventError({this.message});
  final String message;
}
