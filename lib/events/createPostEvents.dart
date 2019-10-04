import 'dart:io';

abstract class CreatePostEvent {}

class EventCreatePost extends CreatePostEvent {
  EventCreatePost({this.content, this.image, this.title});
  String content;
  String title;
  File image;
}

class EventShowPreview extends CreatePostEvent {
  EventShowPreview({this.image, this.title, this.content});
  EventShowPreview.fromCreatePost(EventCreatePost e)
      : this.image = e.image,
        this.title = e.title,
        this.content = e.content;
  final String content;
  final String title;
  final File image;
}

class EventClosePreview extends CreatePostEvent {}


abstract class CreatePostUiEvent {}

class UiEventShowPreview extends CreatePostUiEvent {
  UiEventShowPreview({this.image, this.title, this.content});
  UiEventShowPreview.fromEvent(EventShowPreview event)
      : this.content = event.content,
        this.title = event.title,
        this.image = event.image;
  final String content;
  final String title;
  final File image;
}

class UiEventClosePreview extends CreatePostUiEvent {}

class UiEventPostCreated extends CreatePostUiEvent {}

class UiEventLoading extends CreatePostUiEvent {}

class EventErrorCreatePost {
  EventErrorCreatePost(this.errorMessage);
  final String errorMessage;
}
