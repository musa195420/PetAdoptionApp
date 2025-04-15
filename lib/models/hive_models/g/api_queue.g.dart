// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../api_queue.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class APIQueueAdapter extends TypeAdapter<APIQueue> {
  @override
  final int typeId = 42;

  @override
  APIQueue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return APIQueue(
      id: fields[0] as String,
      data: fields[1] as dynamic,
      type: fields[2] as num,
      printed: fields[3] as bool,
      param: fields[4] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, APIQueue obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.printed)
      ..writeByte(4)
      ..write(obj.param);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is APIQueueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
