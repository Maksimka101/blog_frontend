import 'package:blog_frontend/ui/screens/findUserScreen.dart';
import 'package:blog_frontend/ui/screens/newsFeedScreen.dart';
import 'package:blog_frontend/ui/screens/settingsScreen.dart';
import 'package:blog_frontend/ui/screens/userPostsScreen.dart';
import 'package:blog_frontend/ui/widgets/offsetAppbar.dart';
import 'package:blog_frontend/ui/widgets/offsetTabBar.dart';
import 'package:flutter/material.dart';

class MainAppScreen extends StatefulWidget {
  @override
  _MainAppScreenState createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OffsetAppBar(
        title: Text('Posts'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          NewsFeedScreen(),
          UserPostsScreen(),
          FindUserScreen(),
          SettingsScreen()
        ],
      ),
      bottomNavigationBar: OffsetTabBar(
        backgroundColor: AppBarTheme.of(context).color,
        controller: _tabController,
        tabs: <Widget>[
          Tab(icon: Icon(Icons.list),),
          Tab(icon: Icon(Icons.list),),
          Tab(icon: Icon(Icons.list),),
          Tab(icon: Icon(Icons.list),),
        ],
      ),
    );
  }
}
