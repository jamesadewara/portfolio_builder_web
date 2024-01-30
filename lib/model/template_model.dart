import 'package:hive/hive.dart';

part 'database/template_model.g.dart';

@HiveType(typeId: 1)
class TemplateModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? defaultImage;

  @HiveField(4)
  final String? mobileImage;

  @HiveField(5)
  final String? file;

  @HiveField(6)
  final String? createdAt;

  @HiveField(7)
  final String? updatedAt;

  TemplateModel({
    required this.id,
    this.name,
    this.description,
    this.defaultImage,
    this.mobileImage,
    this.file,
    this.createdAt,
    this.updatedAt,
  });
}
