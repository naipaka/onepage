// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateRequest implements DiagnosticableTreeMixin {

/// The version of the app being requested.
@versionConverter Version get version;/// The message prompting the app update.
 String get message;
/// Create a copy of UpdateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateRequestCopyWith<UpdateRequest> get copyWith => _$UpdateRequestCopyWithImpl<UpdateRequest>(this as UpdateRequest, _$identity);

  /// Serializes this UpdateRequest to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'UpdateRequest'))
    ..add(DiagnosticsProperty('version', version))..add(DiagnosticsProperty('message', message));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateRequest&&(identical(other.version, version) || other.version == version)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,message);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'UpdateRequest(version: $version, message: $message)';
}


}

/// @nodoc
abstract mixin class $UpdateRequestCopyWith<$Res>  {
  factory $UpdateRequestCopyWith(UpdateRequest value, $Res Function(UpdateRequest) _then) = _$UpdateRequestCopyWithImpl;
@useResult
$Res call({
@versionConverter Version version, String message
});




}
/// @nodoc
class _$UpdateRequestCopyWithImpl<$Res>
    implements $UpdateRequestCopyWith<$Res> {
  _$UpdateRequestCopyWithImpl(this._self, this._then);

  final UpdateRequest _self;
  final $Res Function(UpdateRequest) _then;

/// Create a copy of UpdateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? message = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as Version,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _UpdateRequest with DiagnosticableTreeMixin implements UpdateRequest {
  const _UpdateRequest({@versionConverter required this.version, required this.message});
  factory _UpdateRequest.fromJson(Map<String, dynamic> json) => _$UpdateRequestFromJson(json);

/// The version of the app being requested.
@override@versionConverter final  Version version;
/// The message prompting the app update.
@override final  String message;

/// Create a copy of UpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateRequestCopyWith<_UpdateRequest> get copyWith => __$UpdateRequestCopyWithImpl<_UpdateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateRequestToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'UpdateRequest'))
    ..add(DiagnosticsProperty('version', version))..add(DiagnosticsProperty('message', message));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateRequest&&(identical(other.version, version) || other.version == version)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,message);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'UpdateRequest(version: $version, message: $message)';
}


}

/// @nodoc
abstract mixin class _$UpdateRequestCopyWith<$Res> implements $UpdateRequestCopyWith<$Res> {
  factory _$UpdateRequestCopyWith(_UpdateRequest value, $Res Function(_UpdateRequest) _then) = __$UpdateRequestCopyWithImpl;
@override @useResult
$Res call({
@versionConverter Version version, String message
});




}
/// @nodoc
class __$UpdateRequestCopyWithImpl<$Res>
    implements _$UpdateRequestCopyWith<$Res> {
  __$UpdateRequestCopyWithImpl(this._self, this._then);

  final _UpdateRequest _self;
  final $Res Function(_UpdateRequest) _then;

/// Create a copy of UpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? message = null,}) {
  return _then(_UpdateRequest(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as Version,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
