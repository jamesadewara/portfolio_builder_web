String? validateField(value) {
  if (value.length < 5) {
    return 'Please enter at least 4 characters';
  }

  return null;
}

String? validateDropdownField(value) {
  if (value.length < 5) {
    return 'Please select an option';
  }

  return null;
}

String? validateUserName(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your username';
  }
  return null;
}

String? validateUserEmail(value) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);

  return value!.isNotEmpty && !regex.hasMatch(value)
      ? 'Enter a valid email address'
      : null;
}

String? validateUserPassword(value) {
  if (value.length < 9) {
    return "please enter at least 8 character";
  }
  return null;
}

String? validateUrl(value) {
  String portfolioName =
      value.toString().replaceAll(RegExp(r' '), '_').toLowerCase();

  return portfolioName;
}
