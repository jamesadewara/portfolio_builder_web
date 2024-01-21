import 'dart:convert';

import 'package:flutter/services.dart';

class Portfolio {
  Portfolio({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final String image;
  final String createdAt;
  final String updatedAt;

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
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
