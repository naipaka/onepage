// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_format.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExportFormat implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ExportFormat'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportFormat);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ExportFormat()';
}


}

/// @nodoc
class $ExportFormatCopyWith<$Res>  {
$ExportFormatCopyWith(ExportFormat _, $Res Function(ExportFormat) __);
}


/// Adds pattern-matching-related methods to [ExportFormat].
extension ExportFormatPatterns on ExportFormat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Pdf value)?  pdf,TResult Function( _Csv value)?  csv,TResult Function( _Markdown value)?  markdown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pdf() when pdf != null:
return pdf(_that);case _Csv() when csv != null:
return csv(_that);case _Markdown() when markdown != null:
return markdown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Pdf value)  pdf,required TResult Function( _Csv value)  csv,required TResult Function( _Markdown value)  markdown,}){
final _that = this;
switch (_that) {
case _Pdf():
return pdf(_that);case _Csv():
return csv(_that);case _Markdown():
return markdown(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Pdf value)?  pdf,TResult? Function( _Csv value)?  csv,TResult? Function( _Markdown value)?  markdown,}){
final _that = this;
switch (_that) {
case _Pdf() when pdf != null:
return pdf(_that);case _Csv() when csv != null:
return csv(_that);case _Markdown() when markdown != null:
return markdown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  pdf,TResult Function()?  csv,TResult Function()?  markdown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pdf() when pdf != null:
return pdf();case _Csv() when csv != null:
return csv();case _Markdown() when markdown != null:
return markdown();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  pdf,required TResult Function()  csv,required TResult Function()  markdown,}) {final _that = this;
switch (_that) {
case _Pdf():
return pdf();case _Csv():
return csv();case _Markdown():
return markdown();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  pdf,TResult? Function()?  csv,TResult? Function()?  markdown,}) {final _that = this;
switch (_that) {
case _Pdf() when pdf != null:
return pdf();case _Csv() when csv != null:
return csv();case _Markdown() when markdown != null:
return markdown();case _:
  return null;

}
}

}

/// @nodoc


class _Pdf extends ExportFormat with DiagnosticableTreeMixin {
  const _Pdf(): super._();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ExportFormat.pdf'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pdf);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ExportFormat.pdf()';
}


}




/// @nodoc


class _Csv extends ExportFormat with DiagnosticableTreeMixin {
  const _Csv(): super._();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ExportFormat.csv'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Csv);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ExportFormat.csv()';
}


}




/// @nodoc


class _Markdown extends ExportFormat with DiagnosticableTreeMixin {
  const _Markdown(): super._();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ExportFormat.markdown'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Markdown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ExportFormat.markdown()';
}


}




// dart format on
