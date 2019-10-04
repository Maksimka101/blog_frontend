import 'package:blog_frontend/model/user.dart';
import 'package:blog_frontend/ui/entity/uiPostEntity.dart';

class UiUserEntity {
  UiUserEntity({this.post, this.user});

  final User user;
  final UiPostEntity post;
}
