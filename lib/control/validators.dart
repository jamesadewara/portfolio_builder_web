String validateEmail(String value) {
  if (value.isEmpty) {
    return "email field should not be empty";
  }
  return "";
}
