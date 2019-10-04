import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/userPostsBloc.dart';
import 'package:blog_frontend/events/createPostEvents.dart';
import 'package:blog_frontend/events/userPostEvents.dart' as userPostEvent;
import 'package:blog_frontend/model/post.dart';
import 'package:blog_frontend/model/response.dart';
import 'package:blog_frontend/repository/backendRepository.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:blog_frontend/repository/firebaseRepository.dart';
import 'package:connectivity/connectivity.dart';

class CreatePostBloc extends BlocBase {
  CreatePostBloc() {
    _events.stream.listen(_listenForEvents);
  }

  final _events = StreamController<CreatePostEvent>.broadcast();
  StreamSink<CreatePostEvent> get events => _events.sink;

  final _uiPostEvents = StreamController<CreatePostUiEvent>.broadcast();
  Stream<CreatePostUiEvent> get uiEvents => _uiPostEvents.stream;

  final _uiErrorEvents = StreamController<EventErrorCreatePost>.broadcast();
  Stream<EventErrorCreatePost> get errorEvents => _uiErrorEvents.stream;

  void _listenForEvents(CreatePostEvent event) {
    switch (event.runtimeType) {
      case EventCreatePost:
        _createPost(event as EventCreatePost);
        break;
      case EventShowPreview:
        _startPreview(event as EventShowPreview);
        break;
      case EventClosePreview:
        _stopPreview();
        break;
    }
  }

  void _startPreview(EventShowPreview event) {
    _uiPostEvents.add(UiEventShowPreview.fromEvent(event));
  }

  void _stopPreview() {
    _uiPostEvents.add(UiEventClosePreview());
  }

  void _createPost(EventCreatePost event) async {
    if (await _isNotConnected()) return;
    _uiPostEvents.add(UiEventLoading());
    final imageUrl = await FirebaseRepository.saveImage(event.image);
    BackendRepository.createPost(Post(
            content: event.content,
            authorId: InternalRepositoryUser.instance.name,
            title: event.title,
            imageUrl: imageUrl))
        .then((response) {
      if (response.status == Status.Ok) {
        BlocProvider.getBloc<UserPostsBloc>().events.add(
            userPostEvent.EventLoadPosts(
                userName: InternalRepositoryUser.instance.name));
        _uiPostEvents.add(UiEventPostCreated());
      } else
        _uiErrorEvents
            .add(EventErrorCreatePost('Ошибка на сервере при создании поста.'));
    });
  }

  Future<bool> _isNotConnected() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      _uiErrorEvents.sink
          .add(EventErrorCreatePost('Нет подключения к интернету.'));
      return true;
    } else
      return false;
  }

  @override
  void dispose() {
    _uiPostEvents.close();
    _events.close();
    _uiErrorEvents.close();
    super.dispose();
  }
}
