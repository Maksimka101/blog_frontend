import 'package:blog_frontend/bloc/loginBloc.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:flutter/material.dart';

class IntroductionLoginScreen extends StatelessWidget {
  IntroductionLoginScreen(this.loginBloc);
  final LoginBloc loginBloc;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: MaterialButton(
                  child: Text("Зарегистрироваться"),
                  onPressed: () {
                    loginBloc.addUiEvents.add(UiEventRegister());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: MaterialButton(
                  child: Text("Авторизироваться"),
                  onPressed: () {
                    loginBloc.addUiEvents.add(UiEventAuthenticate());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: MaterialButton(
                  child: Text("Пропустить"),
                  onPressed: () {
                    loginBloc.authEvents.add(SignInAnonymousEvent());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
