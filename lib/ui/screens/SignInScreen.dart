import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/authBloc.dart';
import 'package:blog_frontend/bloc/loginBloc.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:blog_frontend/ui/widgets/OffsetAppbar.dart';
import 'package:blog_frontend/ui/screens/authorizationScreen.dart';
import 'package:blog_frontend/ui/screens/introductionLoginScreen.dart';
import 'package:blog_frontend/ui/screens/loginScreen.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
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
              LoginScreen(_loginBloc),
              IntroductionLoginScreen(_loginBloc),
              AuthorizationScreen(_loginBloc),
            ],
          )),
    );
  }
}
