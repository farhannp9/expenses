// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accountdto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountDtoAdapter extends TypeAdapter<AccountDto> {
  @override
  final int typeId = 1;

  @override
  AccountDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountDto(
      fields[0] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AccountDto obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
