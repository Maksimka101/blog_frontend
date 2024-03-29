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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        elevation: 9,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Text(
                      "Зарегистрироваться",
                      style: Theme
                          .of(context)
                          .textTheme
                          .title,
                    ),
                    onPressed: () {
                      loginBloc.addUiEvents.add(UiEventRegister());
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Text(
                      "Авторизоваться",
                      style: Theme
                          .of(context)
                          .textTheme
                          .title,
                    ),
                    onPressed: () {
                      loginBloc.addUiEvents.add(UiEventAuthenticate());
                    },
                  ),
                ),
// todo: сделать анонимную авторизацию
//                Padding(
//                  padding:
//                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                  child: RaisedButton(
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.all(Radius.circular(10))
//                    ),
//                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                    child: Text(
//                      "Пропустить",
//                      style: TextStyle(color: Colors.white, fontSize: 20),
//                    ),
//                    onPressed: () {
//                      loginBloc.authEvents.add(SignInAnonymousEvent());
//                    },
//                  ),
//                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
