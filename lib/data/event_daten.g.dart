// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_daten.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 0;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      name: fields[1] as String,
      datum: fields[2] as DateTime,
      standort: fields[3] as String,
      beschreibung: fields[5] as String,
      typ: fields[4] as String,
      adresse: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.datum)
      ..writeByte(3)
      ..write(obj.standort)
      ..writeByte(4)
      ..write(obj.typ)
      ..writeByte(5)
      ..write(obj.beschreibung)
      ..writeByte(6)
      ..write(obj.adresse);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
