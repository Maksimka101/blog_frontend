import 'package:blog_frontend/ui/widgets/common/offsetAppbar.dart';
import 'package:blog_frontend/ui/widgets/common/offsetTabBar.dart';
import 'package:blog_frontend/ui/widgets/common/roundedCard.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  ErrorScreen({this.errorMessage});
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OffsetAppBar(
        title: Text('Ошибка'),
      ),
      body: Center(
        child: RoundedCard(
          margin: EdgeInsets.all(10),
          child: Text(errorMessage, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
        ),
      ),
      bottomNavigationBar: OffsetBottomBar(),
    );
  }
}
