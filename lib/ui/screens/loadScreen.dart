import 'package:flutter/material.dart';

class LoadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("It's load screen. Wait."),
      ),
      body: Center(
        child: Text("Loading..."),
      ),
    );
  }
}
