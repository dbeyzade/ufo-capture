import 'package:flutter_test/flutter_test.dart';
import 'package:ufo_capture_app/models/subscription_model.dart';

void main() {
  group('SubscriptionModel Tests', () {
    test('SubscriptionModel should be created with valid data', () {
      final subscription = SubscriptionModel(
        planName: 'Premium Plan',
        activeModels: ['Model 1', 'Model 2'],
        usageQuota: UsageQuota(
          totalRecordings: 100,
          usedRecordings: 50,
          totalStorageGB: 10.0,
          usedStorageGB: 5.0,
        ),
        startDate: DateTime(2024, 1, 1),
        expiryDate: DateTime(2025, 1, 1),
      );

      expect(subscription.planName, 'Premium Plan');
      expect(subscription.activeModels.length, 2);
      expect(subscription.activeModels, contains('Model 1'));
      expect(subscription.activeModels, contains('Model 2'));
    });

    test('UsageQuota should calculate percentage correctly', () {
      final quota = UsageQuota(
        totalRecordings: 100,
        usedRecordings: 50,
        totalStorageGB: 10.0,
        usedStorageGB: 2.5,
      );

      expect(quota.recordingsPercentage, 50.0);
      expect(quota.storagePercentage, 25.0);
    });

    test('UsageQuota should handle zero total gracefully', () {
      final quota = UsageQuota(
        totalRecordings: 0,
        usedRecordings: 0,
        totalStorageGB: 0.0,
        usedStorageGB: 0.0,
      );

      expect(quota.recordingsPercentage, 0.0);
      expect(quota.storagePercentage, 0.0);
    });

    test('UsageQuota should handle 100% usage', () {
      final quota = UsageQuota(
        totalRecordings: 100,
        usedRecordings: 100,
        totalStorageGB: 50.0,
        usedStorageGB: 50.0,
      );

      expect(quota.recordingsPercentage, 100.0);
      expect(quota.storagePercentage, 100.0);
    });
  });
}
