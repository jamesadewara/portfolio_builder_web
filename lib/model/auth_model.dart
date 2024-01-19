import 'package:hive/hive.dart';

part 'auth_model.g.dart';

@HiveType(typeId: 0)
class AuthModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String userName;

  AuthModel({required this.userId, required this.userName});
}
