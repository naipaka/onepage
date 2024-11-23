// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateRequest _$UpdateRequestFromJson(Map<String, dynamic> json) {
  return _UpdateRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateRequest {
  /// The version of the app being requested.
  @versionConverter
  Version get version => throw _privateConstructorUsedError;

  /// The message prompting the app update.
  String get message => throw _privateConstructorUsedError;

  /// Serializes this UpdateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateRequestCopyWith<UpdateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateRequestCopyWith<$Res> {
  factory $UpdateRequestCopyWith(
          UpdateRequest value, $Res Function(UpdateRequest) then) =
      _$UpdateRequestCopyWithImpl<$Res, UpdateRequest>;
  @useResult
  $Res call({@versionConverter Version version, String message});
}

/// @nodoc
class _$UpdateRequestCopyWithImpl<$Res, $Val extends UpdateRequest>
    implements $UpdateRequestCopyWith<$Res> {
  _$UpdateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as Version,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateRequestImplCopyWith<$Res>
    implements $UpdateRequestCopyWith<$Res> {
  factory _$$UpdateRequestImplCopyWith(
          _$UpdateRequestImpl value, $Res Function(_$UpdateRequestImpl) then) =
      __$$UpdateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@versionConverter Version version, String message});
}

/// @nodoc
class __$$UpdateRequestImplCopyWithImpl<$Res>
    extends _$UpdateRequestCopyWithImpl<$Res, _$UpdateRequestImpl>
    implements _$$UpdateRequestImplCopyWith<$Res> {
  __$$UpdateRequestImplCopyWithImpl(
      _$UpdateRequestImpl _value, $Res Function(_$UpdateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? message = null,
  }) {
    return _then(_$UpdateRequestImpl(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as Version,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateRequestImpl
    with DiagnosticableTreeMixin
    implements _UpdateRequest {
  const _$UpdateRequestImpl(
      {@versionConverter required this.version, required this.message});

  factory _$UpdateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateRequestImplFromJson(json);

  /// The version of the app being requested.
  @override
  @versionConverter
  final Version version;

  /// The message prompting the app update.
  @override
  final String message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UpdateRequest(version: $version, message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UpdateRequest'))
      ..add(DiagnosticsProperty('version', version))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateRequestImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, version, message);

  /// Create a copy of UpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateRequestImplCopyWith<_$UpdateRequestImpl> get copyWith =>
      __$$UpdateRequestImplCopyWithImpl<_$UpdateRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateRequest implements UpdateRequest {
  const factory _UpdateRequest(
      {@versionConverter required final Version version,
      required final String message}) = _$UpdateRequestImpl;

  factory _UpdateRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateRequestImpl.fromJson;

  /// The version of the app being requested.
  @override
  @versionConverter
  Version get version;

  /// The message prompting the app update.
  @override
  String get message;

  /// Create a copy of UpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateRequestImplCopyWith<_$UpdateRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
