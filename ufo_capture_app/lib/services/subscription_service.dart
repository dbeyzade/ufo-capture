import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription_model.dart';

/// Service to manage subscription state and persistence
class SubscriptionService extends ChangeNotifier {
  static const String _keySubscriptionTier = 'subscription_tier';
  static const String _keyTrialStartDate = 'trial_start_date';
  static const String _keyPremiumExpirationDate = 'premium_expiration_date';

  SubscriptionModel? _currentSubscription;

  SubscriptionModel? get currentSubscription => _currentSubscription;

  /// Initialize the subscription service and load saved state
  Future<void> initialize() async {
    await _loadSubscriptionState();
    notifyListeners();
  }

  /// Load subscription state from persistent storage
  Future<void> _loadSubscriptionState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get saved subscription tier
      final tierIndex = prefs.getInt(_keySubscriptionTier) ?? 0;
      final tier = SubscriptionTier.values[tierIndex];
      
      // Get trial start date
      final trialStartTimestamp = prefs.getInt(_keyTrialStartDate);
      final trialStartDate = trialStartTimestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(trialStartTimestamp)
          : null;
      
      // Get premium expiration date
      final expirationTimestamp = prefs.getInt(_keyPremiumExpirationDate);
      final expirationDate = expirationTimestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(expirationTimestamp)
          : null;

      // Calculate if trial is active
      final isTrialActive = _isTrialActive(trialStartDate);
      final daysRemaining = _calculateDaysRemaining(
        tier,
        trialStartDate,
        expirationDate,
      );

      _currentSubscription = SubscriptionModel(
        tier: tier,
        expirationDate: expirationDate,
        isActive: tier != SubscriptionTier.free || isTrialActive,
        isTrialActive: isTrialActive,
        trialStartDate: trialStartDate,
        daysRemaining: daysRemaining,
      );
    } catch (e) {
      // If loading fails, start with free trial
      await _startFreeTrial();
    }
  }

  /// Check if trial is still active
  bool _isTrialActive(DateTime? trialStartDate) {
    if (trialStartDate == null) return false;
    final trialDuration = const Duration(days: 7);
    final trialEndDate = trialStartDate.add(trialDuration);
    return DateTime.now().isBefore(trialEndDate);
  }

  /// Calculate days remaining for subscription
  int _calculateDaysRemaining(
    SubscriptionTier tier,
    DateTime? trialStartDate,
    DateTime? expirationDate,
  ) {
    if (tier == SubscriptionTier.lifetime) {
      return -1; // Never expires
    }

    if (tier == SubscriptionTier.free && trialStartDate != null) {
      final trialEndDate = trialStartDate.add(const Duration(days: 7));
      final remaining = trialEndDate.difference(DateTime.now()).inDays;
      return remaining > 0 ? remaining : 0;
    }

    if (expirationDate != null) {
      final remaining = expirationDate.difference(DateTime.now()).inDays;
      return remaining > 0 ? remaining : 0;
    }

    return 0;
  }

  /// Start free trial for new users
  Future<void> _startFreeTrial() async {
    final prefs = await SharedPreferences.getInstance();
    final trialStartDate = DateTime.now();
    
    await prefs.setInt(_keySubscriptionTier, SubscriptionTier.free.index);
    await prefs.setInt(
      _keyTrialStartDate,
      trialStartDate.millisecondsSinceEpoch,
    );

    _currentSubscription = SubscriptionModel(
      tier: SubscriptionTier.free,
      isActive: true,
      isTrialActive: true,
      trialStartDate: trialStartDate,
      expirationDate: trialStartDate.add(const Duration(days: 7)),
      daysRemaining: 7,
    );
    
    notifyListeners();
  }

  /// Upgrade to premium subscription
  Future<void> upgradeToPremium({bool isYearly = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    // Use DateTime manipulation for accurate yearly calculations (handles leap years)
    final expirationDate = isYearly
        ? DateTime(now.year + 1, now.month, now.day)
        : now.add(const Duration(days: 30));

    await prefs.setInt(_keySubscriptionTier, SubscriptionTier.premium.index);
    await prefs.setInt(
      _keyPremiumExpirationDate,
      expirationDate.millisecondsSinceEpoch,
    );

    _currentSubscription = SubscriptionModel(
      tier: SubscriptionTier.premium,
      isActive: true,
      isTrialActive: false,
      expirationDate: expirationDate,
      daysRemaining: isYearly ? 365 : 30,
    );

    notifyListeners();
  }

  /// Upgrade to lifetime subscription
  Future<void> upgradeToLifetime() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setInt(_keySubscriptionTier, SubscriptionTier.lifetime.index);
    await prefs.remove(_keyPremiumExpirationDate);

    _currentSubscription = SubscriptionModel(
      tier: SubscriptionTier.lifetime,
      isActive: true,
      isTrialActive: false,
      daysRemaining: -1,
    );

    notifyListeners();
  }

  /// Check if a specific feature is available
  bool hasFeature(String featureId) {
    return _currentSubscription?.hasFeature(featureId) ?? false;
  }

  /// Get all available features
  List<SubscriptionFeature> getAvailableFeatures() {
    return _currentSubscription?.availableFeatures ?? [];
  }

  /// Restore previous purchase (mock implementation)
  Future<bool> restorePurchases() async {
    // In a real implementation, this would communicate with
    // App Store / Play Store to restore purchases
    // For now, we'll just reload the current state
    await _loadSubscriptionState();
    return true;
  }

  /// Cancel subscription (revert to free tier)
  Future<void> cancelSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setInt(_keySubscriptionTier, SubscriptionTier.free.index);
    await prefs.remove(_keyPremiumExpirationDate);
    await prefs.remove(_keyTrialStartDate);

    _currentSubscription = SubscriptionModel.free();
    
    notifyListeners();
  }
}
