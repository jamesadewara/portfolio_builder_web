import 'package:hive/hive.dart';

part 'bucket_model.g.dart';

@HiveType(typeId: 1)
class BucketModel extends HiveObject {
  @HiveField(0)
  dynamic service = true;

  BucketModel({required this.service});
}
