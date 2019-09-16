import 'package:blog_frontend/ui/widgets/OffsetAppbar.dart';
import 'package:flutter/material.dart';

class LoadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OffsetAppBar(
        backgroundColor: AppBarTheme.of(context).color,
        child: Text('Загрузка'),
      ),
      body: Center(
        child: CircularProgressIndicator()
      ),
    );
  }
}
