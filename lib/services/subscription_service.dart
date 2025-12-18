import 'package:flutter/foundation.dart';
import '../models/subscription_model.dart';

/// Service to manage subscription data
class SubscriptionService extends ChangeNotifier {
  SubscriptionModel? _subscription;

  SubscriptionModel? get subscription => _subscription;

  /// Initialize with mock subscription data
  /// In a real app, this would fetch from an API or local storage
  void loadSubscription() {
    _subscription = SubscriptionModel(
      planName: 'Premium Plan',
      activeModels: [
        'RGB Capture',
        'Infrared Detection',
        'Night Vision',
        'Motion Detection',
        'Ultra Violet Filter',
      ],
      usageQuota: UsageQuota(
        totalRecordings: 1000,
        usedRecordings: 347,
        totalStorageGB: 50.0,
        usedStorageGB: 23.5,
      ),
      startDate: DateTime.now().subtract(const Duration(days: 45)),
      expiryDate: DateTime.now().add(const Duration(days: 320)),
    );
    notifyListeners();
  }

  /// Refresh subscription data
  Future<void> refreshSubscription() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    loadSubscription();
  }
}
