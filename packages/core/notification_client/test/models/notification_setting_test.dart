import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:notification_client/notification_client.dart';

void main() {
  group('NotificationSetting', () {
    test('creates instance with required parameters', () {
      const setting = NotificationSetting(
        id: 1,
        hour: 8,
        isEnabled: true,
      );

      expect(setting.id, 1);
      expect(setting.hour, 8);
      expect(setting.isEnabled, true);
    });

    test('creates instance with default isEnabled false', () {
      const setting = NotificationSetting(
        id: 2,
        hour: 12,
        isEnabled: false,
      );

      expect(setting.id, 2);
      expect(setting.hour, 12);
      expect(setting.isEnabled, false);
    });

    test('supports equality comparison', () {
      const setting1 = NotificationSetting(
        id: 1,
        hour: 8,
        isEnabled: true,
      );

      const setting2 = NotificationSetting(
        id: 1,
        hour: 8,
        isEnabled: true,
      );

      const setting3 = NotificationSetting(
        id: 2,
        hour: 8,
        isEnabled: true,
      );

      expect(setting1, equals(setting2));
      expect(setting1, isNot(equals(setting3)));
    });

    test('supports copyWith', () {
      const original = NotificationSetting(
        id: 1,
        hour: 8,
        isEnabled: false,
      );

      final updated = original.copyWith(isEnabled: true);

      expect(updated.id, 1);
      expect(updated.hour, 8);
      expect(updated.isEnabled, true);
    });

    test('supports copyWith with partial updates', () {
      const original = NotificationSetting(
        id: 1,
        hour: 8,
        isEnabled: false,
      );

      final updatedHour = original.copyWith(hour: 20);
      final updatedEnabled = original.copyWith(isEnabled: true);
      final updatedId = original.copyWith(id: 5);

      expect(updatedHour.hour, 20);
      expect(updatedHour.id, 1);
      expect(updatedHour.isEnabled, false);

      expect(updatedEnabled.isEnabled, true);
      expect(updatedEnabled.id, 1);
      expect(updatedEnabled.hour, 8);

      expect(updatedId.id, 5);
      expect(updatedId.hour, 8);
      expect(updatedId.isEnabled, false);
    });

    group('JSON serialization', () {
      test('converts to JSON correctly', () {
        const setting = NotificationSetting(
          id: 1,
          hour: 8,
          isEnabled: true,
        );

        final json = setting.toJson();

        expect(json, {
          'id': 1,
          'hour': 8,
          'isEnabled': true,
        });
      });

      test('creates from JSON correctly', () {
        final json = {
          'id': 2,
          'hour': 20,
          'isEnabled': false,
        };

        final setting = NotificationSetting.fromJson(json);

        expect(setting.id, 2);
        expect(setting.hour, 20);
        expect(setting.isEnabled, false);
      });

      test('round-trip JSON serialization', () {
        const original = NotificationSetting(
          id: 3,
          hour: 12,
          isEnabled: true,
        );

        final json = original.toJson();
        final restored = NotificationSetting.fromJson(json);

        expect(restored, equals(original));
      });

      test('JSON string serialization', () {
        const setting = NotificationSetting(
          id: 1,
          hour: 8,
          isEnabled: true,
        );

        final jsonString = jsonEncode(setting.toJson());
        final decodedJson = jsonDecode(jsonString) as Map<String, dynamic>;
        final restored = NotificationSetting.fromJson(decodedJson);

        expect(restored, equals(setting));
      });
    });

    test('has proper toString representation', () {
      const setting = NotificationSetting(
        id: 1,
        hour: 8,
        isEnabled: true,
      );

      final string = setting.toString();
      expect(string, contains('NotificationSetting'));
      expect(string, contains('id: 1'));
      expect(string, contains('hour: 8'));
      expect(string, contains('isEnabled: true'));
    });

    test('has proper hashCode implementation', () {
      const setting1 = NotificationSetting(
        id: 1,
        hour: 8,
        isEnabled: true,
      );

      const setting2 = NotificationSetting(
        id: 1,
        hour: 8,
        isEnabled: true,
      );

      const setting3 = NotificationSetting(
        id: 2,
        hour: 8,
        isEnabled: true,
      );

      expect(setting1.hashCode, equals(setting2.hashCode));
      expect(setting1.hashCode, isNot(equals(setting3.hashCode)));
    });
  });
}
