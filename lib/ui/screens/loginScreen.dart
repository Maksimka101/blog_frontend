import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/authBloc.dart';
import 'package:blog_frontend/bloc/loginBloc.dart';
import 'package:blog_frontend/ui/widgets/OffsetAppbar.dart';
import 'package:blog_frontend/ui/widgets/authWidget.dart';
import 'package:blog_frontend/ui/widgets/introductionLoginWidget.dart';
import 'package:blog_frontend/ui/widgets/loginWidget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc(authBloc: BlocProvider.getBloc<AuthBloc>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ));
  }
}
