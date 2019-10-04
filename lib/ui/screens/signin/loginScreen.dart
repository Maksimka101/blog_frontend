import 'package:blog_frontend/bloc/loginBloc.dart';
import 'package:blog_frontend/events/loginEvents.dart';
import 'package:blog_frontend/ui/widgets/common/errorAlertDialog.dart';
import 'package:blog_frontend/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen(this.loginBloc);

  final LoginBloc loginBloc;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();

  final _loginScreenValidator = LoginScreenValidator();

  final _registerEvent = RegisterEvent();

  void _listenEvent(UiEventLogin event, BuildContext context) {
    switch (event.runtimeType) {
      case UiEventLoginError:
        showAlertDialog(context, (event as UiEventLoginError).errorMessage);
        break;
    }
  }

  void _pickImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _registerEvent.userAvatar = image;
    setState(() {});
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) => widget.loginBloc.uiEvents
        .listen((event) => _listenEvent(event, context)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              InkWell(
                child: CircleAvatar(
                  radius: 90,
                  backgroundImage: _registerEvent.userAvatar != null ? FileImage(_registerEvent.userAvatar) : null,
                  child: _registerEvent.userAvatar == null
                      ? Text(
                          "Нажмите, чтобы выбрать фото",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700),
                        )
                      : null,
                ),
                onTap: _pickImage,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(9))),
                    hintText: "Введите ваше имя",
                  ),
                  validator: _loginScreenValidator.nameValidator,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(9))),
                    hintText: "Введите ваш пароль",
                  ),
                  validator: _loginScreenValidator.firstPasswordValidator,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(9))),
                    hintText: "Подтвердите пароль",
                  ),
                  validator: _loginScreenValidator.secondPasswordValidator,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    "Зарегистрироваться",
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  ),
                  onPressed: () {
                    if (_form.currentState.validate()) {
                      final userName = _loginScreenValidator.userName;
                      final userPassword = _loginScreenValidator.userPassword;
                      _registerEvent.userName = userName;
                      _registerEvent.userPassword = userPassword;
                      widget.loginBloc.authEvents.add(_registerEvent);
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
