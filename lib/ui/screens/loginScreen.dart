import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/authBloc.dart';
import 'package:blog_frontend/bloc/loginBloc.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:blog_frontend/ui/widgets/OffsetAppbar.dart';
import 'package:blog_frontend/ui/widgets/authWidget.dart';
import 'package:blog_frontend/ui/widgets/introductionLoginWidget.dart';
import 'package:blog_frontend/ui/widgets/loginWidget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _loginBloc = LoginBloc(authBloc: BlocProvider.getBloc<AuthBloc>());
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _loginBloc.uiEvents.listen(_uiEventListener);
    super.initState();
  }

  void _uiEventListener(UiEventLogin event) {
    switch (event.runtimeType) {
      case UiEventRegister:
        _tabController.animateTo(2);
        break;
      case UiEventRegister:
        _tabController.animateTo(0);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _tabController.animateTo(1);
        return false;
      },
      child: Scaffold(
          appBar: OffsetAppBar(
            backgroundColor: AppBarTheme.of(context).color,
            child: Text("Регистрация"),
          ),
          body: TabBarView(
            children: <Widget>[
              LoginWidget(_loginBloc),
              IntroductionLoginWidget(_loginBloc),
              AuthWidget(_loginBloc),
            ],
          )),
    );
  }
}
