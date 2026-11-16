import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider_utils/src/provider_logger.dart';
import 'package:simple_logger/simple_logger.dart';

import '../util/provider_container.dart';

void main() {
  group('ProviderEvent', () {
    test('getEventsFromNames should return correct events', () {
      final events = ProviderEvent.getEventsFromNames('add,update,error');
      expect(
        events,
        [ProviderEvent.add, ProviderEvent.update, ProviderEvent.error],
      );
    });

    test('getEventsFromNames should return mutation events', () {
      final events = ProviderEvent.getEventsFromNames(
        'mutationStart,mutationSuccess,mutationError,mutationReset',
      );
      expect(
        events,
        [
          ProviderEvent.mutationStart,
          ProviderEvent.mutationSuccess,
          ProviderEvent.mutationError,
          ProviderEvent.mutationReset,
        ],
      );
    });

    test('getEventsFromNames should return empty list for empty string', () {
      final events = ProviderEvent.getEventsFromNames('');
      expect(events, <ProviderEvent>[]);
    });

    test('getEventsFromNames should throw error for invalid event name', () {
      expect(
        () => ProviderEvent.getEventsFromNames('invalid'),
        throwsArgumentError,
      );
    });
  });

  group('ProviderLogger', () {
    final logger = SimpleLogger();
    late List<LogInfo> logs;

    setUp(() {
      logs = [];
      final level = logger.level;
      final stackTraceLevel = logger.stackTraceLevel;
      final includeCallerInfo = logger.includeCallerInfo;
      final callerInfoFrameLevelOffset = logger.callerInfoFrameLevelOffset;
      final mode = logger.mode;
      final onLogged = logger.onLogged;
      logger
        ..setLevel(Level.FINEST)
        ..mode = LoggerMode.log
        ..onLogged = (_, info) => logs.add(info);
      addTearDown(() {
        logger
          ..setLevel(
            level,
            stackTraceLevel: stackTraceLevel,
            includeCallerInfo: includeCallerInfo,
            callerInfoFrameLevelOffset: callerInfoFrameLevelOffset,
          )
          ..mode = mode
          ..onLogged = onLogged;
      });
    });

    List<(Level, String)> loggedMessages() => [
      for (final log in logs) (log.level, log.message),
    ];

    test('should log add event', () {
      final providerLogger = ProviderLogger(
        outputLogTypes: [ProviderEvent.add],
        logger: logger,
      );
      final container = createContainer(observers: [providerLogger]);
      final provider = Provider((ref) => 'test');

      container.read(provider);

      expect(loggedMessages(), [
        (Level.FINEST, '[ADD] Provider<String> - test'),
      ]);
    });

    test('should log update event', () {
      final providerLogger = ProviderLogger(
        outputLogTypes: [ProviderEvent.update],
        logger: logger,
      );
      final container = createContainer(observers: [providerLogger]);
      final provider = StateProvider((ref) => 'test');

      container.read(provider.notifier).state = 'updated';

      expect(loggedMessages(), [
        (Level.FINEST, '[UPDATE] StateProvider<String> - updated'),
      ]);
    });

    test('should log dispose event', () {
      final providerLogger = ProviderLogger(
        outputLogTypes: [ProviderEvent.dispose],
        logger: logger,
      );
      final container = createContainer(observers: [providerLogger]);
      final provider = Provider((ref) => 'test');

      container
        ..read(provider)
        ..dispose();

      expect(loggedMessages(), [(Level.FINEST, '[DISPOSE] Provider<String> ')]);
    });

    test('should log error event', () {
      final providerLogger = ProviderLogger(
        outputLogTypes: [ProviderEvent.error],
        logger: logger,
      );
      final container = createContainer(observers: [providerLogger]);
      final provider = Provider<String>((ref) => throw Exception('test error'));

      expect(() => container.read(provider), throwsException);

      expect(loggedMessages(), [
        (Level.FINEST, '[ERROR] Provider<String> - Exception: test error'),
      ]);
    });

    test('should not log any events if outputLogTypes is empty', () {
      final emptyLogger = ProviderLogger(
        outputLogTypes: [],
        logger: logger,
      );
      final container = createContainer(observers: [emptyLogger]);
      final provider = StateProvider((ref) => 'test');

      container.read(provider);
      container.read(provider.notifier).state = 'updated';
      container.dispose();

      expect(logs, isEmpty);
    });

    test('should log mutationStart and mutationSuccess events', () async {
      final providerLogger = ProviderLogger(
        outputLogTypes: [
          ProviderEvent.mutationStart,
          ProviderEvent.mutationSuccess,
        ],
        logger: logger,
      );
      final container = createContainer(observers: [providerLogger]);
      final testMutation = Mutation<String>();

      await testMutation.run(container, (_) async => 'success');

      expect(logs.map((log) => log.level), everyElement(Level.FINEST));
      expect(logs.map((log) => log.message), [
        contains('[MUTATIONSTART]'),
        contains('[MUTATIONSUCCESS]'),
      ]);
    });

    test('should log mutationError event when mutation fails', () async {
      final providerLogger = ProviderLogger(
        outputLogTypes: [
          ProviderEvent.mutationStart,
          ProviderEvent.mutationError,
        ],
        logger: logger,
      );
      final container = createContainer(observers: [providerLogger]);
      final testMutation = Mutation<String>();

      await expectLater(
        testMutation.run(container, (_) async {
          throw Exception('test error');
        }),
        throwsException,
      );

      expect(logs.map((log) => log.level), everyElement(Level.FINEST));
      expect(logs.map((log) => log.message), [
        contains('[MUTATIONSTART]'),
        contains('[MUTATIONERROR]'),
      ]);
    });

    test('should log mutationReset event', () async {
      final providerLogger = ProviderLogger(
        outputLogTypes: [ProviderEvent.mutationReset],
        logger: logger,
      );
      final container = createContainer(observers: [providerLogger]);
      final testMutation = Mutation<String>();

      // Run mutation first to create a state
      await testMutation.run(container, (_) async => 'success');

      // Then reset it
      testMutation.reset(container);

      expect(logs.map((log) => log.level), everyElement(Level.FINEST));
      expect(logs.map((log) => log.message), [contains('[MUTATIONRESET]')]);
    });
  });
}
