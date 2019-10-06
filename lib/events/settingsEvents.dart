import 'dart:io';

abstract class SettingsEvent {}

class EventChangeUserIcon extends SettingsEvent {
  EventChangeUserIcon({this.image});

  File image;
}

class EventLoadUserInfo extends SettingsEvent {}

abstract class SettingsUiDataEvent {}

class UiEventUserInfo extends SettingsUiDataEvent {
  UiEventUserInfo({this.imageUrl, this.name});

  final String imageUrl;
  final String name;
}

abstract class SettingsUiEvent {}

class ErrorUiEvent extends SettingsUiEvent {
  ErrorUiEvent(this.errorMessage);

  final String errorMessage;
}

class UiEventUserImageLoading extends SettingsUiEvent {}
