import 'package:blog_frontend/ui/entity/uiPostEntity.dart';

class UiUserEntity {
  UiUserEntity({this.post, this.userName, this.userImageUrl});

  final String userName;
  final String userImageUrl;
  final UiPostEntity post;
}
