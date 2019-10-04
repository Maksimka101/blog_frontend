import 'dart:io';

abstract class CreatePostEvent {}

class EventCreatePost extends CreatePostEvent {
  EventCreatePost(
      {this.content,
      this.image,
      this.title,
      this.id,
      this.imageUrl,
      this.date});
  String imageUrl;
  String content;
  String title;
  File image;
  DateTime date;
  int id;
}

class EventShowPreview extends CreatePostEvent {
  EventShowPreview({this.image, this.title, this.content, this.imageUrl});
  EventShowPreview.fromCreatePost(EventCreatePost e)
      : this.image = e.image,
        this.title = e.title,
        this.content = e.content,
        this.imageUrl = e.imageUrl;
  final String content;
  final String title;
  final File image;
  final String imageUrl;
}

class EventClosePreview extends CreatePostEvent {}

abstract class CreatePostUiEvent {}

class UiEventShowPreview extends CreatePostUiEvent {
  UiEventShowPreview({this.image, this.title, this.content, this.imageUrl});
  UiEventShowPreview.fromEvent(EventShowPreview event)
      : this.content = event.content,
        this.title = event.title,
        this.image = event.image,
        this.imageUrl = event.imageUrl;
  final String content;
  final String title;
  final File image;
  final String imageUrl;
}

class UiEventClosePreview extends CreatePostUiEvent {}

class UiEventPostCreated extends CreatePostUiEvent {}

class UiEventLoading extends CreatePostUiEvent {}

class EventErrorCreatePost {
  EventErrorCreatePost(this.errorMessage);
  final String errorMessage;
}
