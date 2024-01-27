import 'dart:convert';

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

stringToJson(String data) {
  String jsonString = data;

  // Remove the outer double quotes and unescape the string
  jsonString = jsonString.substring(1, jsonString.length - 1);
  jsonString = jsonString.replaceAll(r'\"', '"');

  // Parse the string as JSON
  Map<String, dynamic> jsonData = json.decode(jsonString);

  return jsonData;
}
