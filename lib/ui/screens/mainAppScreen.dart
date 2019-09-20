import 'package:blog_frontend/ui/screens/findUserScreen.dart';
import 'package:blog_frontend/ui/screens/newsFeedScreen.dart';
import 'package:blog_frontend/ui/screens/settingsScreen.dart';
import 'package:blog_frontend/ui/screens/userPostsScreen.dart';
import 'package:blog_frontend/ui/widgets/common/offsetAppbar.dart';
import 'package:blog_frontend/ui/widgets/common/offsetTabBar.dart';
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
        title: Text('Блог'),
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
      bottomNavigationBar: OffsetNavigationBar(
        controller: _tabController,
        tabs: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
              title: Text('Новости')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind),
              title: Text('Мои посты')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.group_add),
              title: Text('Найти друга')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Настройки')
          ),
        ]
      ),
    );
  }
}
