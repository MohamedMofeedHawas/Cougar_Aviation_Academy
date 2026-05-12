// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aircraft_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AircraftModelAdapter extends TypeAdapter<AircraftModel> {
  @override
  final int typeId = 2;

  @override
  AircraftModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AircraftModel(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      engine: fields[3] as String,
      maxAltitude: fields[4] as String,
      range: fields[5] as String,
      description: fields[6] as String,
      imageUrl: fields[7] as String?,
      specs: (fields[8] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, AircraftModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.engine)
      ..writeByte(4)
      ..write(obj.maxAltitude)
      ..writeByte(5)
      ..write(obj.range)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.specs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AircraftModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AircraftModelImpl _$$AircraftModelImplFromJson(Map<String, dynamic> json) =>
    _$AircraftModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      engine: json['engine'] as String,
      maxAltitude: json['maxAltitude'] as String,
      range: json['range'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      specs: (json['specs'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$AircraftModelImplToJson(_$AircraftModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'engine': instance.engine,
      'maxAltitude': instance.maxAltitude,
      'range': instance.range,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'specs': instance.specs,
    };
