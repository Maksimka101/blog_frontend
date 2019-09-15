import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/authBloc.dart';
import 'package:blog_frontend/bloc/loginBloc.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:blog_frontend/utils/validators.dart';
import 'package:flutter/material.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget(this.loginBloc);
  final LoginBloc loginBloc;
  final _form = GlobalKey<FormState>();
  final _loginScreenValidator = LoginScreenValidator();

  // todo Сверстать
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              CircleAvatar(
                child: Text("Выберите фото"),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Введите ваше имя",
                ),
                validator: _loginScreenValidator.nameValidator,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Введите ваш пароль",
                ),
                validator: _loginScreenValidator.firstPasswordValidator,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Подтвердите пароль",
                ),
                validator: _loginScreenValidator.secondPasswordValidator,
              ),
              MaterialButton(
                child: Text("Зарегистрироваться"),
                onPressed: () {
                  if (_form.currentState.validate()) {
                    final userName = _loginScreenValidator.userName;
                    final userPassword = _loginScreenValidator.userPassword;
                    // todo: add user avatar
                    loginBloc.authEvents.add(RegisterEvent(
                          userName: userName,
                          userPassword: userPassword,
//                    userAvatar: userAvatar
                        ));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
