import 'package:blog_frontend/ui/widgets/roundedCard.dart';
import 'package:blog_frontend/ui/widgets/userTile.dart';
import 'package:flutter/material.dart';

class ExpandedUserCard extends StatelessWidget {
  ExpandedUserCard({this.userName, this.imageUrl});
  final String userName;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      child: UserTile(
        imageUrl: imageUrl,
        userName: userName,
      ),
    );
  }
}
