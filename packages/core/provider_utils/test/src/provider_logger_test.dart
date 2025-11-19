import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider_utils/src/provider_logger.dart';

import '../util/mock.mocks.dart';
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
    test('should log add event', () {
      final mockLogger = MockSimpleLogger();
      final providerLogger = ProviderLogger(
        outputLogTypes: [ProviderEvent.add],
        logger: mockLogger,
      );
      final container = createContainer(observers: [providerLogger]);
      final provider = Provider((ref) => 'test');

      container.read(provider);

      verify(mockLogger.finest('[ADD] Provider<String> - test')).called(1);
    });

    test('should log update event', () {
      final mockLogger = MockSimpleLogger();
      final providerLogger = ProviderLogger(
        outputLogTypes: [ProviderEvent.update],
        logger: mockLogger,
      );
      final container = createContainer(observers: [providerLogger]);
      final provider = StateProvider((ref) => 'test');

      container.read(provider.notifier).state = 'updated';

      verify(
        mockLogger.finest('[UPDATE] StateProvider<String> - updated'),
      ).called(1);
    });

    test('should log dispose event', () {
      final mockLogger = MockSimpleLogger();
      final providerLogger = ProviderLogger(
        outputLogTypes: [ProviderEvent.dispose],
        logger: mockLogger,
      );
      final container = createContainer(observers: [providerLogger]);
      final provider = Provider((ref) => 'test');

      container
        ..read(provider)
        ..dispose();

      verify(mockLogger.finest('[DISPOSE] Provider<String> ')).called(1);
    });

    test('should log error event', () {
      final mockLogger = MockSimpleLogger();
      final providerLogger = ProviderLogger(
        outputLogTypes: [ProviderEvent.error],
        logger: mockLogger,
      );
      final container = createContainer(observers: [providerLogger]);
      final provider = Provider<String>((ref) => throw Exception('test error'));

      expect(() => container.read(provider), throwsException);

      verify(
        mockLogger.finest('[ERROR] Provider<String> - Exception: test error'),
      ).called(1);
    });

    test('should not log any events if outputLogTypes is empty', () {
      final mockLogger = MockSimpleLogger();
      final emptyLogger = ProviderLogger(
        outputLogTypes: [],
        logger: mockLogger,
      );
      final container = createContainer(observers: [emptyLogger]);
      final provider = StateProvider((ref) => 'test');

      container.read(provider);
      container.read(provider.notifier).state = 'updated';
      container.dispose();

      verifyNever(mockLogger.finest(any));
    });

    test('should log mutationStart and mutationSuccess events', () async {
      final mockLogger = MockSimpleLogger();
      final providerLogger = ProviderLogger(
        outputLogTypes: [
          ProviderEvent.mutationStart,
          ProviderEvent.mutationSuccess,
        ],
        logger: mockLogger,
      );
      final container = createContainer(observers: [providerLogger]);
      final testMutation = Mutation<String>();

      await testMutation.run(container, (_) async => 'success');

      verify(mockLogger.finest(argThat(contains('[MUTATIONSTART]')))).called(1);
      verify(
        mockLogger.finest(argThat(contains('[MUTATIONSUCCESS]'))),
      ).called(1);
    });

    test('should log mutationError event when mutation fails', () async {
      final mockLogger = MockSimpleLogger();
      final providerLogger = ProviderLogger(
        outputLogTypes: [
          ProviderEvent.mutationStart,
          ProviderEvent.mutationError,
        ],
        logger: mockLogger,
      );
      final container = createContainer(observers: [providerLogger]);
      final testMutation = Mutation<String>();

      await expectLater(
        testMutation.run(container, (_) async {
          throw Exception('test error');
        }),
        throwsException,
      );

      verify(mockLogger.finest(argThat(contains('[MUTATIONSTART]')))).called(1);
      verify(mockLogger.finest(argThat(contains('[MUTATIONERROR]')))).called(1);
    });

    test('should log mutationReset event', () async {
      final mockLogger = MockSimpleLogger();
      final providerLogger = ProviderLogger(
        outputLogTypes: [ProviderEvent.mutationReset],
        logger: mockLogger,
      );
      final container = createContainer(observers: [providerLogger]);
      final testMutation = Mutation<String>();

      // Run mutation first to create a state
      await testMutation.run(container, (_) async => 'success');

      // Then reset it
      testMutation.reset(container);

      verify(mockLogger.finest(argThat(contains('[MUTATIONRESET]')))).called(1);
    });
  });
}
