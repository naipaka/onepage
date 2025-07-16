import 'dart:async';

import 'package:configurator/src/config.dart';
import 'package:configurator/src/configurator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:firebase_remote_config_platform_interface/firebase_remote_config_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import '../utils/firebase_remote_config.mock.dart';
import '../utils/mock.mocks.dart';

void main() {
  group('constructor', () {
    test('Can create an instance', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      setupFirebaseCoreMocks();
      await Firebase.initializeApp();
      final mockPlatform = MockFirebaseRemoteConfigPlatform();
      FirebaseRemoteConfigPlatform.instance = mockPlatform;

      final target = Configurator();
      expect(target, isA<Configurator>());
    });
  });

  group('fetchAndActivate', () {
    test('Can fetch and activate remote config', () async {
      final mockRC = MockFirebaseRemoteConfig();
      final target = Configurator.forTesting(mockRC);

      when(mockRC.fetchAndActivate()).thenAnswer((_) async => true);

      final result = await target.fetchAndActivate();

      expect(result, isTrue);
    });
  });

  group('activate', () {
    test('Can activate remote config', () async {
      final mockRC = MockFirebaseRemoteConfig();
      final target = Configurator.forTesting(mockRC);

      when(mockRC.activate()).thenAnswer((_) async => true);

      final result = await target.activate();

      expect(result, isTrue);
    });
  });

  group('configure', () {
    test('Can configure remote config settings', () async {
      final mockRC = MockFirebaseRemoteConfig();
      final target = Configurator.forTesting(mockRC);

      const fetchTimeout = Duration(seconds: 10);
      const minimumFetchInterval = Duration(minutes: 5);

      await target.configure(
        fetchTimeout: fetchTimeout,
        minimumFetchInterval: minimumFetchInterval,
      );

      verify(
        mockRC.setConfigSettings(
          argThat(
            predicate<RemoteConfigSettings>(
              (settings) =>
                  settings.fetchTimeout == fetchTimeout &&
                  settings.minimumFetchInterval == minimumFetchInterval,
            ),
          ),
        ),
      );
    });
  });

  group('setDefaults', () {
    test('Can set defaults with String values', () async {
      final mockRC = MockFirebaseRemoteConfig();
      final target = Configurator.forTesting(mockRC);

      await target.setDefaults({'key': 'value'});

      verify(mockRC.setDefaults({'key': 'value'}));
    });

    test('Error occurs when setting a Class instance as a value', () {
      final mockRC = MockFirebaseRemoteConfig();
      final target = Configurator.forTesting(mockRC);

      expect(
        () async =>
            target.setDefaults({'key': const DataClass(value: 'value')}),
        throwsAssertionError,
      );
    });

    test('Error occurs when setting a List type as a value', () {
      final mockRC = MockFirebaseRemoteConfig();
      final target = Configurator.forTesting(mockRC);

      expect(
        () async => target.setDefaults({
          'key': ['ABC', 'DEF'],
        }),
        throwsAssertionError,
      );
    });

    test('Error occurs when setting a Map type as a value', () {
      final mockRC = MockFirebaseRemoteConfig();
      final target = Configurator.forTesting(mockRC);

      expect(
        () async => target.setDefaults({
          'key': {'key': 'value'},
        }),
        throwsAssertionError,
      );
    });
  });

  group('onConfigUpdated', () {
    test('Can retrieve the Stream of RemoteConfigUpdate', () async {
      final mockRC = MockFirebaseRemoteConfig();
      final target = Configurator.forTesting(mockRC);

      final stream = target.onConfigUpdated;
      expect(stream, isA<Stream<RemoteConfigUpdate>>());
    });
  });

  group('filteredOnConfigUpdated', () {
    test(
      'Can retrieve the Stream of RemoteConfigUpdate filtered by key',
      () async {
        final mockRC = MockFirebaseRemoteConfig();
        final target = Configurator.forTesting(mockRC);

        const key = 'string_001';

        final stream = target.filteredOnConfigUpdated(key);
        expect(stream, isA<Stream<RemoteConfigUpdate>>());
      },
    );
  });

  group('getString', () {
    test('Can retrieve the Remote string corresponding to the key', () {
      final mockRC = MockFirebaseRemoteConfig();
      when(mockRC.getString('string_001')).thenReturn('string_value');
      final target = Configurator.forTesting(mockRC);

      const key = 'string_001';

      final value = target.getString(key);
      expect(value, equals('string_value'));
    });
  });

  group('getInt', () {
    test('Can retrieve the Remote integer corresponding to the key', () {
      final mockRC = MockFirebaseRemoteConfig();
      when(mockRC.getInt('int_001')).thenReturn(1);
      final target = Configurator.forTesting(mockRC);

      const key = 'int_001';

      final value = target.getInt(key);
      expect(value, equals(1));
    });
  });

  group('getDouble', () {
    test(
      'Can retrieve the Remote floating-point number corresponding to the key',
      () {
        final mockRC = MockFirebaseRemoteConfig();
        when(mockRC.getDouble('double_001')).thenReturn(0.1);
        final target = Configurator.forTesting(mockRC);

        const key = 'double_001';

        final value = target.getDouble(key);
        expect(value, equals(0.1));
      },
    );
  });

  group('getBool', () {
    test('Can retrieve the boolean value corresponding to the key', () {
      final mockRC = MockFirebaseRemoteConfig();
      when(mockRC.getBool('bool_001')).thenReturn(true);
      final target = Configurator.forTesting(mockRC);

      const key = 'bool_001';

      final value = target.getBool(key);
      expect(value, isTrue);
    });
  });

  group('getJson', () {
    test('Can retrieve the JSON (Map) corresponding to the key', () {
      final mockRC = MockFirebaseRemoteConfig();
      when(mockRC.getString('json_001')).thenReturn('''
      {
        "value_1": "01",
        "value_2": 2,
        "value_3": 3.0,
        "value_4": true
      }
      ''');
      final target = Configurator.forTesting(mockRC);

      const key = 'json_001';

      final value = target.getJson(key);
      expect(value, <String, Object?>{
        'value_1': '01',
        'value_2': 2,
        'value_3': 3.0,
        'value_4': true,
      });
    });
  });

  group('getListJson', () {
    test('Can retrieve the list of JSON (Map) corresponding to the key', () {
      final mockRC = MockFirebaseRemoteConfig();
      when(mockRC.getString('list_json_001')).thenReturn('''
      [
        {
          "value_1a": "01a",
          "value_2a": 2,
          "value_3a": 3.0,
          "value_4a": true
        },
        {
          "value_1b": "01b",
          "value_2b": 20,
          "value_3b": 3.5,
          "value_4b": false
        }
      ]
      ''');
      final target = Configurator.forTesting(mockRC);

      const key = 'list_json_001';

      final value = target.getListJson(key);
      expect(
        value,
        [
          {
            'value_1a': '01a',
            'value_2a': 2,
            'value_3a': 3.0,
            'value_4a': true,
          },
          {
            'value_1b': '01b',
            'value_2b': 20,
            'value_3b': 3.5,
            'value_4b': false,
          },
        ],
      );
    });
  });

  group('getData', () {
    test('Can retrieve the class object corresponding to the key', () {
      final mockRC = MockFirebaseRemoteConfig();
      when(mockRC.getString('data_001')).thenReturn('''
      {
        "value": "tokyo"
      }
      ''');
      final target = Configurator.forTesting(mockRC);

      const key = 'data_001';

      final value = target.getData(key: key, fromJson: DataClass.fromJson);

      expect(value, const DataClass(value: 'tokyo'));
    });
  });

  group('getStringConfig', () {
    test(
      'Can retrieve the Config<String> corresponding to the key',
      () async {
        final mockRC = MockFirebaseRemoteConfig();
        when(mockRC.getString('string_001')).thenReturn('string_value');
        final streamController = StreamController<RemoteConfigUpdate>();
        when(mockRC.onConfigUpdated).thenAnswer((_) => streamController.stream);
        final target = Configurator.forTesting(mockRC);

        const key = 'string_001';
        var updatedValue = '';

        final config = target.getStringConfig(
          key,
          onConfigUpdated: (value) {
            updatedValue = value;
          },
        );
        addTearDown(config.dispose);
        addTearDown(streamController.close);

        expect(config, isA<Config<String>>());
        expect(config.value, equals('string_value'));

        streamController.add(
          RemoteConfigUpdate(<String>{key}),
        );

        await pumpEventQueue();

        expect(updatedValue, equals('string_value'));
      },
    );
  });

  group('getIntConfig', () {
    test(
      'Can retrieve the Config<int> corresponding to the key',
      () async {
        final mockRC = MockFirebaseRemoteConfig();
        when(mockRC.getInt('int_001')).thenReturn(1);
        final streamController = StreamController<RemoteConfigUpdate>();
        when(mockRC.onConfigUpdated).thenAnswer((_) => streamController.stream);
        final target = Configurator.forTesting(mockRC);

        const key = 'int_001';
        var updatedValue = 0;

        final config = target.getIntConfig(
          key,
          onConfigUpdated: (value) {
            updatedValue = value;
          },
        );
        addTearDown(config.dispose);
        addTearDown(streamController.close);

        expect(config, isA<Config<int>>());
        expect(config.value, equals(1));

        streamController.add(
          RemoteConfigUpdate(<String>{key}),
        );

        await pumpEventQueue();

        expect(updatedValue, equals(1));
      },
    );
  });

  group('getDoubleConfig', () {
    test(
      'Can retrieve the Config<double> corresponding to the key',
      () async {
        final mockRC = MockFirebaseRemoteConfig();
        when(mockRC.getDouble('double_001')).thenReturn(0.1);
        final streamController = StreamController<RemoteConfigUpdate>();
        when(mockRC.onConfigUpdated).thenAnswer((_) => streamController.stream);
        final target = Configurator.forTesting(mockRC);

        const key = 'double_001';
        var updatedValue = 0.0;

        final config = target.getDoubleConfig(
          key,
          onConfigUpdated: (value) {
            updatedValue = value;
          },
        );
        addTearDown(config.dispose);
        addTearDown(streamController.close);

        expect(config, isA<Config<double>>());
        expect(config.value, equals(0.1));

        streamController.add(
          RemoteConfigUpdate(<String>{key}),
        );

        await pumpEventQueue();

        expect(updatedValue, equals(0.1));
      },
    );
  });

  group('getBoolConfig', () {
    test(
      'Can retrieve the Config<bool> corresponding to the key',
      () async {
        final mockRC = MockFirebaseRemoteConfig();
        when(mockRC.getBool('bool_001')).thenReturn(true);
        final streamController = StreamController<RemoteConfigUpdate>();
        when(mockRC.onConfigUpdated).thenAnswer((_) => streamController.stream);
        final target = Configurator.forTesting(mockRC);

        const key = 'bool_001';
        var updatedValue = false;

        final config = target.getBoolConfig(
          key,
          onConfigUpdated: (value) {
            updatedValue = value;
          },
        );
        addTearDown(config.dispose);
        addTearDown(streamController.close);

        expect(config, isA<Config<bool>>());
        expect(config.value, isTrue);

        streamController.add(
          RemoteConfigUpdate(<String>{key}),
        );

        await pumpEventQueue();

        expect(updatedValue, isTrue);
      },
    );
  });

  group('getJsonConfig', () {
    test(
      'Can retrieve the Config<Map<String, Object?>> '
      'corresponding to the key',
      () async {
        final mockRC = MockFirebaseRemoteConfig();
        when(mockRC.getString('json_001')).thenReturn('''
      {
        "value_1": "01",
        "value_2": 2,
        "value_3": 3.0,
        "value_4": true
      }
      ''');
        final streamController = StreamController<RemoteConfigUpdate>();
        when(mockRC.onConfigUpdated).thenAnswer((_) => streamController.stream);
        final target = Configurator.forTesting(mockRC);

        const key = 'json_001';
        var updatedValue = <String, Object?>{};

        final config = target.getJsonConfig(
          key,
          onConfigUpdated: (value) {
            updatedValue = value;
          },
        );
        addTearDown(config.dispose);
        addTearDown(streamController.close);

        expect(config, isA<Config<Map<String, Object?>>>());
        expect(config.value, <String, Object?>{
          'value_1': '01',
          'value_2': 2,
          'value_3': 3.0,
          'value_4': true,
        });

        streamController.add(
          RemoteConfigUpdate(<String>{key}),
        );

        await pumpEventQueue();

        expect(updatedValue, <String, Object?>{
          'value_1': '01',
          'value_2': 2,
          'value_3': 3.0,
          'value_4': true,
        });
      },
    );
  });

  group('getListJsonConfig', () {
    test(
      'Can retrieve the Config<List<Map<String, Object?>>> '
      'corresponding to the key',
      () async {
        final mockRC = MockFirebaseRemoteConfig();
        when(mockRC.getString('list_json_001')).thenReturn('''
      [
        {
          "value_1a": "01a",
          "value_2a": 2,
          "value_3a": 3.0,
          "value_4a": true
        },
        {
          "value_1b": "01b",
          "value_2b": 20,
          "value_3b": 3.5,
          "value_4b": false
        }
      ]
      ''');
        final streamController = StreamController<RemoteConfigUpdate>();
        when(mockRC.onConfigUpdated).thenAnswer((_) => streamController.stream);
        final target = Configurator.forTesting(mockRC);

        const key = 'list_json_001';
        var updatedValue = <Map<String, Object?>>[];

        final config = target.getListJsonConfig(
          key,
          onConfigUpdated: (value) {
            updatedValue = value;
          },
        );
        addTearDown(config.dispose);
        addTearDown(streamController.close);

        expect(config, isA<Config<List<Map<String, Object?>>>>());
        expect(
          config.value,
          [
            {
              'value_1a': '01a',
              'value_2a': 2,
              'value_3a': 3.0,
              'value_4a': true,
            },
            {
              'value_1b': '01b',
              'value_2b': 20,
              'value_3b': 3.5,
              'value_4b': false,
            },
          ],
        );

        streamController.add(
          RemoteConfigUpdate(<String>{key}),
        );

        await pumpEventQueue();

        expect(
          updatedValue,
          [
            {
              'value_1a': '01a',
              'value_2a': 2,
              'value_3a': 3.0,
              'value_4a': true,
            },
            {
              'value_1b': '01b',
              'value_2b': 20,
              'value_3b': 3.5,
              'value_4b': false,
            },
          ],
        );
      },
    );
  });

  group('getDataConfig', () {
    test(
      'Can retrieve the Config<Object> corresponding to the key',
      () async {
        final mockRC = MockFirebaseRemoteConfig();
        when(mockRC.getString('data_001')).thenReturn('''
      {
        "value": "tokyo"
      }
      ''');
        final streamController = StreamController<RemoteConfigUpdate>();
        when(mockRC.onConfigUpdated).thenAnswer((_) => streamController.stream);
        final target = Configurator.forTesting(mockRC);

        const key = 'data_001';
        var updatedValue = const DataClass(value: '');

        final config = target.getDataConfig(
          key,
          fromJson: DataClass.fromJson,
          onConfigUpdated: (value) {
            updatedValue = value;
          },
        );
        addTearDown(config.dispose);
        addTearDown(streamController.close);

        expect(config, isA<Config<DataClass>>());
        expect(config.value, const DataClass(value: 'tokyo'));

        streamController.add(
          RemoteConfigUpdate(<String>{key}),
        );

        await pumpEventQueue();

        expect(updatedValue, const DataClass(value: 'tokyo'));
      },
    );
  });
}

@immutable
class DataClass {
  const DataClass({required this.value});

  factory DataClass.fromJson(Map<String, dynamic> json) =>
      DataClass(value: json['value'] as String);

  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataClass &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => '_Data(value: $value)';
}
