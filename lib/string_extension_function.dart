extension StringValidation on String {
  /////// for email validation
  bool get isValidEmail {
    String pattern = r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(this);
  }

////////  for password validation
  bool get isValidPassword {
    return (isNotEmpty && length > 8 && length <= 12);
  }
}
