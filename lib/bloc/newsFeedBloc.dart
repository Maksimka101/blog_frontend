import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/events/newsEvent.dart';
import 'package:blog_frontend/model/comment.dart';
import 'package:blog_frontend/model/response.dart';
import 'package:blog_frontend/repository/backendRepository.dart';
import 'package:blog_frontend/repository/entity/repositoryClient.dart';
import 'package:blog_frontend/repository/entity/repositoryUserEntity.dart';
import 'package:blog_frontend/ui/entity/uiUserEntity.dart';
import 'package:rxdart/rxdart.dart';

class NewsFeedBloc extends BlocBase {
  NewsFeedBloc() {
    _postEvents.stream.listen(_listenPostEvent);
  }

  void _listenPostEvent(PostEvent event) {
    switch (event.runtimeType) {
      case EventLoadPosts:
        _loadUserSubscriptions(event as EventLoadPosts);
        break;
      case EventFilterUsers:
        _filterUsers(event as EventFilterUsers);
        break;
      case EventCreateComment:
        _createComment(event as EventCreateComment);
        break;
    }
  }

  void _filterUsers(EventFilterUsers event) {
    if (event.showAllUsers)
      _uiDataPostEvent.add(UiEventUsersAndPosts(usersAndPosts: _previousPosts));
    else {
      _uiDataPostEvent.add(UiEventUsersAndPosts(
          usersAndPosts: <RepositoryUserEntity>[
            _previousPosts.where((user) => user.name == event.userName).first
          ]));
    }
  }

  void _loadUserSubscriptions(EventLoadPosts event) {
    BackendRepository.getAllUserSubscription(event.userName).then((usersResponse) {
      if (usersResponse.status == Status.Ok) {
        _uiDataPostEvent.add(UiEventSmallUsersAndPosts(
            posts: _convertAndSortPosts(usersResponse.typedBody.list)));
        _previousPosts = usersResponse.typedBody.list;
      } else {
        _uiPostEvent.add(UiEventError(
            message: 'Ошибка при загрузки с сервера. Проверьте подключение '
                'к интернету или попробуйте перезайти.'));
      }
    });
  }

  void _createComment(EventCreateComment event) {
    final comment = Comment(
      content: event.message,
      postId: event.postId,
      authorId: InternalRepositoryUser.instance.name
    );
    BackendRepository.createComment(comment);
  }

  List<UiUserEntity>
      _convertAndSortPosts(List<RepositoryUserEntity> users) => users
          .map((user) => user
              .posts
              .map((post) => UiUserEntity(
                  userName: user.name, post: post, userImageUrl: user.imageUrl))
              .toList())
          .reduce((list, elem) => list..addAll(elem))
            ..sort((user1, user2) =>
                -user1.post.createDate.compareTo(user2.post.createDate));

  List<RepositoryUserEntity> _previousPosts;

  final _scrollPositionScream = PublishSubject<double>();

  Stream<double> get scrollPosition => _scrollPositionScream.stream;

  StreamSink<double> get updateScrollPosition => _scrollPositionScream.sink;

  final _postEvents = PublishSubject<PostEvent>();

//  Stream<PostEvent> get postEvent => _postEvents.stream;
  StreamSink<PostEvent> get addPostEvent => _postEvents.sink;

  final _uiPostEvent = PublishSubject<UiPostEvent>();

  Stream<UiPostEvent> get uiPostEvent => _uiPostEvent.stream;

  StreamSink<UiPostEvent> get addUiPostEvent => _uiPostEvent.sink;

  final _uiDataPostEvent = PublishSubject<UiDataPostEvent>();

  Stream<UiDataPostEvent> get uiDataPostEvent => _uiDataPostEvent.stream;

  void dispose() {
    _postEvents.close();
    _uiDataPostEvent.close();
    _scrollPositionScream.close();
    super.dispose();
  }
}
