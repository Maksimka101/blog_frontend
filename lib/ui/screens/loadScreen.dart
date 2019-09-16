import 'package:blog_frontend/ui/widgets/offsetAppbar.dart';
import 'package:flutter/material.dart';

class LoadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OffsetAppBar(
        title: Text('Загрузка'),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
