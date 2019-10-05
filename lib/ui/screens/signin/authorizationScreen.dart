import 'package:blog_frontend/bloc/loginBloc.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:blog_frontend/ui/widgets/common/errorAlertDialog.dart';
import 'package:blog_frontend/utils/validators.dart';
import 'package:flutter/material.dart';

class AuthorizationScreen extends StatelessWidget {
  AuthorizationScreen(this.loginBloc);

  final LoginBloc loginBloc;
  final _authScreenValidator = AuthScreenValidator();
  final _form = GlobalKey<FormState>();

  void _listenEvent(UiEventLogin event, BuildContext context) {
    switch (event.runtimeType) {
      case UiEventAuthenticateError:
        showAlertDialog(context, (event as UiEventAuthenticateError).errorMessage);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 0)).then((_) =>
        loginBloc.uiEvents.listen((event) => _listenEvent(event, context)));
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: CircleAvatar(
                  radius: 75,
                  child: Text(
                    'App logo',
                    style: Theme
                        .of(context)
                        .textTheme
                        .body2,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: TextFormField(
                  style: Theme
                      .of(context)
                      .textTheme
                      .body1,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme
                                .of(context)
                                .accentColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(9))),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme
                                .of(context)
                                .buttonColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(9))),
                      hintText: "Введите ваше имя",
                      hintStyle: Theme
                          .of(context)
                          .textTheme
                          .body1
                  ),
                  validator: _authScreenValidator.nameValidator,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: TextFormField(
                  style: Theme
                      .of(context)
                      .textTheme
                      .body1,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme
                                .of(context)
                                .accentColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(9))),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme
                                .of(context)
                                .buttonColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(9))),
                      hintText: "Введите ваш пароль",
                      hintStyle: Theme
                          .of(context)
                          .textTheme
                          .body1
                  ),
                  validator: _authScreenValidator.passwordValidator,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    "Авторизоваться",
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  ),
                  onPressed: () {
                    if (_form.currentState.validate()) {
                      final userName = _authScreenValidator.userName;
                      final userPassword = _authScreenValidator.userPassword;
                      loginBloc.authEvents.add(AuthenticateEvent(
                        userPassword: userPassword,
                        userName: userName,
                      ));
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
