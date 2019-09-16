class LoginScreenValidator {

  String userName;
  String userPassword;
  String _firstPassword;

  String nameValidator(String name) {
    if (name.length < 4) return "Слишком короткое имя";
    if (name.length > 16) return "Слишком длинное имя";
    userName = name;
    return null;
  }

  String firstPasswordValidator(String password) {
    if (password.length < 6) return "Слишком короткий пароль";
    if (password.length > 16) return "Слишком длинный пароль";
    if (!password.contains("1234567890")) return "Слишком ненадежный пароль. Пароль должен содержать цифры";
    _firstPassword = password;
    return null;
  }

  String secondPasswordValidator(String password) {
    if (password.length < 6) return "Слишком короткий пароль";
    if (password.length > 16) return "Слишком длинный пароль";
    if (!password.contains("1234567890")) return "Слишком ненадежный пароль. Пароль должен содержать цифры";
    if (password != _firstPassword) return "Пароли должны совподать";
    return null;
  }

}

class AuthScreenValidator {
  String userName;
  String userPassword;

  String nameValidator(String name) {
    if (name.length < 4) return "Слишком короткое имя";
    if (name.length > 16) return "Слишком длинное имя";
    userName = name;
    return null;
  }

  String passwordValidator(String password) {
    if (password.length < 6) return "Слишком короткий пароль";
    if (password.length > 16) return "Слишком длинный пароль";
    if (!password.contains("1234567890")) return "Слишком ненадежный пароль. Пароль должен содержать цифры";
    userPassword = password;
    return null;
  }
}