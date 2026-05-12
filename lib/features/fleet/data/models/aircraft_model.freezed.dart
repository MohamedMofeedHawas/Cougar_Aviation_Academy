// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aircraft_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AircraftModel _$AircraftModelFromJson(Map<String, dynamic> json) {
  return _AircraftModel.fromJson(json);
}

/// @nodoc
mixin _$AircraftModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get type => throw _privateConstructorUsedError;
  @HiveField(3)
  String get engine => throw _privateConstructorUsedError;
  @HiveField(4)
  String get maxAltitude => throw _privateConstructorUsedError;
  @HiveField(5)
  String get range => throw _privateConstructorUsedError;
  @HiveField(6)
  String get description => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get imageUrl => throw _privateConstructorUsedError;
  @HiveField(8)
  Map<String, String>? get specs => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AircraftModelCopyWith<AircraftModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AircraftModelCopyWith<$Res> {
  factory $AircraftModelCopyWith(
          AircraftModel value, $Res Function(AircraftModel) then) =
      _$AircraftModelCopyWithImpl<$Res, AircraftModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String type,
      @HiveField(3) String engine,
      @HiveField(4) String maxAltitude,
      @HiveField(5) String range,
      @HiveField(6) String description,
      @HiveField(7) String? imageUrl,
      @HiveField(8) Map<String, String>? specs});
}

/// @nodoc
class _$AircraftModelCopyWithImpl<$Res, $Val extends AircraftModel>
    implements $AircraftModelCopyWith<$Res> {
  _$AircraftModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? engine = null,
    Object? maxAltitude = null,
    Object? range = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? specs = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      engine: null == engine
          ? _value.engine
          : engine // ignore: cast_nullable_to_non_nullable
              as String,
      maxAltitude: null == maxAltitude
          ? _value.maxAltitude
          : maxAltitude // ignore: cast_nullable_to_non_nullable
              as String,
      range: null == range
          ? _value.range
          : range // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      specs: freezed == specs
          ? _value.specs
          : specs // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AircraftModelImplCopyWith<$Res>
    implements $AircraftModelCopyWith<$Res> {
  factory _$$AircraftModelImplCopyWith(
          _$AircraftModelImpl value, $Res Function(_$AircraftModelImpl) then) =
      __$$AircraftModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String type,
      @HiveField(3) String engine,
      @HiveField(4) String maxAltitude,
      @HiveField(5) String range,
      @HiveField(6) String description,
      @HiveField(7) String? imageUrl,
      @HiveField(8) Map<String, String>? specs});
}

/// @nodoc
class __$$AircraftModelImplCopyWithImpl<$Res>
    extends _$AircraftModelCopyWithImpl<$Res, _$AircraftModelImpl>
    implements _$$AircraftModelImplCopyWith<$Res> {
  __$$AircraftModelImplCopyWithImpl(
      _$AircraftModelImpl _value, $Res Function(_$AircraftModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? engine = null,
    Object? maxAltitude = null,
    Object? range = null,
    Object? description = null,
    Object? imageUrl = freezed,
    Object? specs = freezed,
  }) {
    return _then(_$AircraftModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      engine: null == engine
          ? _value.engine
          : engine // ignore: cast_nullable_to_non_nullable
              as String,
      maxAltitude: null == maxAltitude
          ? _value.maxAltitude
          : maxAltitude // ignore: cast_nullable_to_non_nullable
              as String,
      range: null == range
          ? _value.range
          : range // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      specs: freezed == specs
          ? _value._specs
          : specs // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AircraftModelImpl implements _AircraftModel {
  const _$AircraftModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) required this.type,
      @HiveField(3) required this.engine,
      @HiveField(4) required this.maxAltitude,
      @HiveField(5) required this.range,
      @HiveField(6) required this.description,
      @HiveField(7) this.imageUrl,
      @HiveField(8) final Map<String, String>? specs})
      : _specs = specs;

  factory _$AircraftModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AircraftModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String type;
  @override
  @HiveField(3)
  final String engine;
  @override
  @HiveField(4)
  final String maxAltitude;
  @override
  @HiveField(5)
  final String range;
  @override
  @HiveField(6)
  final String description;
  @override
  @HiveField(7)
  final String? imageUrl;
  final Map<String, String>? _specs;
  @override
  @HiveField(8)
  Map<String, String>? get specs {
    final value = _specs;
    if (value == null) return null;
    if (_specs is EqualUnmodifiableMapView) return _specs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AircraftModel(id: $id, name: $name, type: $type, engine: $engine, maxAltitude: $maxAltitude, range: $range, description: $description, imageUrl: $imageUrl, specs: $specs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AircraftModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.engine, engine) || other.engine == engine) &&
            (identical(other.maxAltitude, maxAltitude) ||
                other.maxAltitude == maxAltitude) &&
            (identical(other.range, range) || other.range == range) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._specs, _specs));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      engine,
      maxAltitude,
      range,
      description,
      imageUrl,
      const DeepCollectionEquality().hash(_specs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AircraftModelImplCopyWith<_$AircraftModelImpl> get copyWith =>
      __$$AircraftModelImplCopyWithImpl<_$AircraftModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AircraftModelImplToJson(
      this,
    );
  }
}

abstract class _AircraftModel implements AircraftModel {
  const factory _AircraftModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(2) required final String type,
      @HiveField(3) required final String engine,
      @HiveField(4) required final String maxAltitude,
      @HiveField(5) required final String range,
      @HiveField(6) required final String description,
      @HiveField(7) final String? imageUrl,
      @HiveField(8) final Map<String, String>? specs}) = _$AircraftModelImpl;

  factory _AircraftModel.fromJson(Map<String, dynamic> json) =
      _$AircraftModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String get type;
  @override
  @HiveField(3)
  String get engine;
  @override
  @HiveField(4)
  String get maxAltitude;
  @override
  @HiveField(5)
  String get range;
  @override
  @HiveField(6)
  String get description;
  @override
  @HiveField(7)
  String? get imageUrl;
  @override
  @HiveField(8)
  Map<String, String>? get specs;
  @override
  @JsonKey(ignore: true)
  _$$AircraftModelImplCopyWith<_$AircraftModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
