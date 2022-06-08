// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedListAdapter extends TypeAdapter<SavedList> {
  @override
  final int typeId = 1;

  @override
  SavedList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedList(
      cityName: fields[0] as String,
      countryName: fields[1] as String,
      flagPath: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SavedList obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.cityName)
      ..writeByte(1)
      ..write(obj.countryName)
      ..writeByte(2)
      ..write(obj.flagPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
