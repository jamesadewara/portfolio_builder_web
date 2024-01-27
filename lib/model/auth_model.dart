import 'package:hive/hive.dart';

part 'auth_model.g.dart';

@HiveType(typeId: 0)
class AuthModel extends HiveObject {
  @HiveField(0)
  final String token;

  @HiveField(1)
  final String? uid;

  @HiveField(2)
  final String? userName;

  @HiveField(3)
  final String? userEmail;

  AuthModel({
    required this.token,
    this.uid,
    this.userName,
    this.userEmail,
  });
}
