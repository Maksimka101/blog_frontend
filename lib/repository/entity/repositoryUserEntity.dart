import 'package:blog_frontend/model/serializable.dart';
import 'package:blog_frontend/ui/entity/uiPostEntity.dart';
import 'package:blog_frontend/ui/entity/uiUserEntity.dart';

class RepositoryUserEntity implements Serializable {
  String name;
  String imageUrl;
  final List<UiPostEntity> posts = [];

  @override
  void fromJson(json) {
    name = json['name'];
    imageUrl = json['image_url'];
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
        .map((user) =>
        user.posts
            .map((post) =>
            UiUserEntity(
                userName: user.name, post: post, userImageUrl: user.imageUrl))
            .toList())
        .reduce((list, elem) => list..addAll(elem))
      ..sort((user1, user2) =>
      -user1.post.createDate.compareTo(user2.post.createDate));
    else
      return <UiUserEntity>[];
  }
}
