// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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


/// Adds pattern-matching-related methods to [UpdateRequest].
extension UpdateRequestPatterns on UpdateRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@versionConverter  Version version,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateRequest() when $default != null:
return $default(_that.version,_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@versionConverter  Version version,  String message)  $default,) {final _that = this;
switch (_that) {
case _UpdateRequest():
return $default(_that.version,_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@versionConverter  Version version,  String message)?  $default,) {final _that = this;
switch (_that) {
case _UpdateRequest() when $default != null:
return $default(_that.version,_that.message);case _:
  return null;

}
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
