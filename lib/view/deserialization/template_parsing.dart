import 'package:portfolio_builder_app/model/bucket.dart';

class Template {
  Template({
    required this.id,
    required this.name,
    required this.description,
    required this.templateFile,
    required this.defaultImage,
    required this.mobileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final String templateFile;
  final String defaultImage;
  final String mobileImage;
  final String createdAt;
  final String updatedAt;

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      defaultImage: json["default_image"],
      mobileImage: json["mobile_image"],
      templateFile: json["template_file"],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

Future<List<Template>> fetchTemplateData(context) async {
  Bucket bucketTemplate = Bucket();

  // const String jsonData =
  //     '{"data": [{"title": "Item 1", "description": "Description 1"}, {"title": "Item 2", "description": "Description 2"}]}';
  final List<dynamic> jsonList = await bucketTemplate.fetchTemplates(context);

  return jsonList.map((json) => Template.fromJson(json)).toList();
}
