import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'aircraft_model.freezed.dart';
part 'aircraft_model.g.dart';

@freezed
@HiveType(typeId: 2)
class AircraftModel with _$AircraftModel {
  const factory AircraftModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String type,
    @HiveField(3) required String engine,
    @HiveField(4) required String maxAltitude,
    @HiveField(5) required String range,
    @HiveField(6) required String description,
    @HiveField(7) String? imageUrl,
    @HiveField(8) Map<String, String>? specs,
  }) = _AircraftModel;

  factory AircraftModel.fromJson(Map<String, dynamic> json) => _$AircraftModelFromJson(json);
}
