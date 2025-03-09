// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateRequest _$UpdateRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_UpdateRequest', json, ($checkedConvert) {
      final val = _UpdateRequest(
        version: $checkedConvert(
          'version',
          (v) => versionConverter.fromJson(v as String),
        ),
        message: $checkedConvert('message', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$UpdateRequestToJson(_UpdateRequest instance) =>
    <String, dynamic>{
      'version': versionConverter.toJson(instance.version),
      'message': instance.message,
    };
