import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

@freezed
@HiveType(typeId: 1)
class CourseModel with _$CourseModel {
  const factory CourseModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String description,
    @HiveField(3) required String duration,
    @HiveField(4) required String level,
    @HiveField(5) required String aircraftType,
    @HiveField(6) List<String>? requirements,
    @HiveField(7) List<String>? syllabus,
    @HiveField(8) String? imageUrl,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) => _$CourseModelFromJson(json);
}
