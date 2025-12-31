// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_diary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExportDiary implements DiagnosticableTreeMixin {

/// The date of the diary entry.
 DateTime get date;/// The content of the diary entry.
 String get content;
/// Create a copy of ExportDiary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportDiaryCopyWith<ExportDiary> get copyWith => _$ExportDiaryCopyWithImpl<ExportDiary>(this as ExportDiary, _$identity);

  /// Serializes this ExportDiary to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ExportDiary'))
    ..add(DiagnosticsProperty('date', date))..add(DiagnosticsProperty('content', content));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportDiary&&(identical(other.date, date) || other.date == date)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,content);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ExportDiary(date: $date, content: $content)';
}


}

/// @nodoc
abstract mixin class $ExportDiaryCopyWith<$Res>  {
  factory $ExportDiaryCopyWith(ExportDiary value, $Res Function(ExportDiary) _then) = _$ExportDiaryCopyWithImpl;
@useResult
$Res call({
 DateTime date, String content
});




}
/// @nodoc
class _$ExportDiaryCopyWithImpl<$Res>
    implements $ExportDiaryCopyWith<$Res> {
  _$ExportDiaryCopyWithImpl(this._self, this._then);

  final ExportDiary _self;
  final $Res Function(ExportDiary) _then;

/// Create a copy of ExportDiary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? content = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportDiary].
extension ExportDiaryPatterns on ExportDiary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportDiary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportDiary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportDiary value)  $default,){
final _that = this;
switch (_that) {
case _ExportDiary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportDiary value)?  $default,){
final _that = this;
switch (_that) {
case _ExportDiary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportDiary() when $default != null:
return $default(_that.date,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  String content)  $default,) {final _that = this;
switch (_that) {
case _ExportDiary():
return $default(_that.date,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  String content)?  $default,) {final _that = this;
switch (_that) {
case _ExportDiary() when $default != null:
return $default(_that.date,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExportDiary with DiagnosticableTreeMixin implements ExportDiary {
  const _ExportDiary({required this.date, required this.content});
  factory _ExportDiary.fromJson(Map<String, dynamic> json) => _$ExportDiaryFromJson(json);

/// The date of the diary entry.
@override final  DateTime date;
/// The content of the diary entry.
@override final  String content;

/// Create a copy of ExportDiary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportDiaryCopyWith<_ExportDiary> get copyWith => __$ExportDiaryCopyWithImpl<_ExportDiary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExportDiaryToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ExportDiary'))
    ..add(DiagnosticsProperty('date', date))..add(DiagnosticsProperty('content', content));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportDiary&&(identical(other.date, date) || other.date == date)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,content);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ExportDiary(date: $date, content: $content)';
}


}

/// @nodoc
abstract mixin class _$ExportDiaryCopyWith<$Res> implements $ExportDiaryCopyWith<$Res> {
  factory _$ExportDiaryCopyWith(_ExportDiary value, $Res Function(_ExportDiary) _then) = __$ExportDiaryCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, String content
});




}
/// @nodoc
class __$ExportDiaryCopyWithImpl<$Res>
    implements _$ExportDiaryCopyWith<$Res> {
  __$ExportDiaryCopyWithImpl(this._self, this._then);

  final _ExportDiary _self;
  final $Res Function(_ExportDiary) _then;

/// Create a copy of ExportDiary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? content = null,}) {
  return _then(_ExportDiary(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
