import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/events/settingsEvents.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:blog_frontend/repository/firebaseRepository.dart';
import 'package:blog_frontend/repository/internalRepository.dart';
import 'package:connectivity/connectivity.dart';

class SettingsBloc extends BlocBase {
  SettingsBloc() {
    _events.stream.listen(_listenForEvents);
  }

  final _events = StreamController<SettingsEvent>.broadcast();

  StreamSink<SettingsEvent> get events => _events.sink;

  final _dataEvents = StreamController<SettingsUiDataEvent>.broadcast();

  Stream<SettingsUiDataEvent> get dataEvents => _dataEvents.stream;

  final _uiEvents = StreamController<SettingsUiEvent>.broadcast();

  Stream<SettingsUiEvent> get uiEvents => _uiEvents.stream;

  void _listenForEvents(SettingsEvent event) {
    switch (event.runtimeType) {
      case EventLoadUserInfo:
        _loadUserInfo();
        break;
      case EventChangeUserIcon:
        _changeUserIcon(event as EventChangeUserIcon);
        break;
    }
  }

  void _loadUserInfo() {
    final userImageUrl = InternalRepositoryUser.instance.imageUrl;
    final userName = InternalRepositoryUser.instance.name;
    final userInfo = UiEventUserInfo(imageUrl: userImageUrl, name: userName);
    _dataEvents.add(userInfo);
  }

  void _changeUserIcon(EventChangeUserIcon event) async {
    if (await _checkIsNoConnection()) return;
    _uiEvents.add(UiEventUserImageLoading());
    final imageUrl = await FirebaseRepository.saveImage(event.image);
    if (imageUrl == null) {
      _uiEvents.add(ErrorUiEvent('Не удалось сохранить фото.'));
      return;
    }
    final user = InternalRepositoryUser.instance;
    user.imageUrl = imageUrl;
    BlocProvider.getDependency<InternalRepository>().user = user;
    _events.add(EventLoadUserInfo());
  }

  Future<bool> _checkIsNoConnection() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      _uiEvents.add(ErrorUiEvent('Нет подключения к интернету.'));
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _uiEvents.close();
    _dataEvents.close();
    _events.close();
    super.dispose();
  }
}
