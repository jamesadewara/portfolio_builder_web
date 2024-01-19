// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bucket_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BucketModelAdapter extends TypeAdapter<BucketModel> {
  @override
  final int typeId = 1;

  @override
  BucketModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BucketModel(
      service: fields[0] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, BucketModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.service);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BucketModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
