import 'dart:convert';

import 'package:flutter/services.dart';

class Portfolio {
  Portfolio({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.url,
    required this.templateId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final String image;
  final String url;
  final String templateId;
  final String createdAt;
  final String updatedAt;

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      url:
          "https://stackoverflow.com/questions/55885433/flutter-dart-how-to-add-copy-to-clipboard-on-tap-to-a-app",
      templateId: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

Future<List<Portfolio>> fetchPortfolioData() async {
  // const String jsonData =
  //     '{"data": [{"title": "Item 1", "description": "Description 1"}, {"title": "Item 2", "description": "Description 2"}]}';
  final String jsonData =
      await rootBundle.loadString('assets/json/portfolios.json');

  final List<dynamic> jsonList = json.decode(jsonData);

  return jsonList.map((json) => Portfolio.fromJson(json)).toList();
}
