import 'package:intl/intl.dart';

stringToDateTime(String inputString) {
  // Convert string to DateTime object
  DateTime dateTimeObject = DateTime.parse(inputString);
  return dateTimeObject;
}

formatDateTime(DateTime dateTimeObject) {
  String formattedDate = DateFormat.yMMMMd('en_US').format(dateTimeObject);
  String formattedTime = DateFormat.Hm().format(dateTimeObject);
  return [formattedDate, formattedTime];
}
