class LoginScreenValidator {
  String userName;
  String userPassword;
  String _firstPassword;

  String nameValidator(String name) {
    if (name.length < 4) return "Слишком короткое имя";
    if (name.length > 16) return "Слишком длинное имя";
    if (name.contains(' ')) return 'Имя не может содержать пробелы';
    if (name.contains('&') || name.contains('?')) return 'Имя не может содержать & и ?';
    userName = name;
    return null;
  }

  String firstPasswordValidator(String password) {
    if (password.length < 6) return "Слишком короткий пароль";
    if (password.length > 16) return "Слишком длинный пароль";
    if (!containsNum(password))
      return "Слишком ненадежный пароль. Пароль должен содержать цифры";
    _firstPassword = password;
    return null;
  }

  String secondPasswordValidator(String password) {
    if (password.length < 6) return "Слишком короткий пароль";
    if (password.length > 16) return "Слишком длинный пароль";
    if (password != _firstPassword) return "Пароли должны совподать";
    if (!containsNum(password))
      return "Слишком ненадежный пароль. Пароль должен содержать цифры";
    userPassword = password;
    return null;
  }
}

class AuthScreenValidator {
  String userName;
  String userPassword;

  String nameValidator(String name) {
    if (name.length < 4) return "Слишком короткое имя";
    if (name.length > 16) return "Слишком длинное имя";
    if (name.contains(' ')) return 'Имя не может содержать пробелы';
    if (name.contains('&') || name.contains('?')) return 'Имя не может содержать & и ?';
    userName = name;
    return null;
  }

  String passwordValidator(String password) {
    if (password.length < 6) return "Слишком короткий пароль";
    if (password.length > 16) return "Слишком длинный пароль";
    if (!containsNum(password))
      return "Слишком ненадежный пароль. Пароль должен содержать цифры";
    userPassword = password;
    return null;
  }
}

bool containsNum(String str) {
  for (final i in [1, 2, 3, 4, 5, 6, 7, 8, 9, 0])
    if (str.contains(i.toString())) return true;
  return false;
}
