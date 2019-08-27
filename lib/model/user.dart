import 'post.dart';

class User {
  User(
      {this.uuid,
      this.name,
      this.imageUrl,
      this.posts,
      this.subscribes,
      this.password}) {}

  String uuid;
  String name;
  String imageUrl;
  List<User> subscribes;
  List<Post> posts;
  String password;
}
