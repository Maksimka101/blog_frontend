import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blog_frontend/bloc/AuthBloc.dart';
import 'package:blog_frontend/ui/widgets/OffsetAppbar.dart';
import 'package:blog_frontend/utils/validators.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _loginScreenValidator = LoginScreenValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OffsetAppBar(
        child: Text("Регистрация"),
      ),
      body: Form(
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
                  BlocProvider.getBloc<AuthBloc>()
                      .registerUserByLoginAndPassword(userName, userPassword);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
