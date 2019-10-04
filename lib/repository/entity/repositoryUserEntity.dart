import 'package:blog_frontend/model/serializable.dart';
import 'package:blog_frontend/model/user.dart';
import 'package:blog_frontend/ui/entity/uiPostEntity.dart';
import 'package:blog_frontend/ui/entity/uiUserEntity.dart';

class RepositoryUserEntity implements Serializable {
  User user;
  final List<UiPostEntity> posts = [];

  @override
  void fromJson(json) {
    user = User()..fromJson(json);
    for (final post in json['posts']) {
      posts.add(UiPostEntity()..fromJson(post));
    }
  }

  @override
  toJson() {
    return null;
  }

  static List<UiUserEntity> convertForUiAndSort(
      List<RepositoryUserEntity> users) {
    if (users.isNotEmpty)
      return users
          .map((user) => user.posts
              .map((post) => UiUserEntity(post: post, user: user.user))
              .toList())
          .reduce((list, elem) => list..addAll(elem))
            ..sort((user1, user2) {
              final c = -user1.post.createDate.compareTo(user2.post.createDate);
              return c;
            });
    else
      return <UiUserEntity>[];
  }
}
