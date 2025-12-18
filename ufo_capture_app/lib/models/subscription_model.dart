/// Model representing the subscription status and features
class SubscriptionModel {
  final SubscriptionTier tier;
  final DateTime? expirationDate;
  final bool isActive;
  final bool isTrialActive;
  final DateTime? trialStartDate;
  final int daysRemaining;

  SubscriptionModel({
    required this.tier,
    this.expirationDate,
    required this.isActive,
    required this.isTrialActive,
    this.trialStartDate,
    required this.daysRemaining,
  });

  /// Get list of all available features for current subscription
  List<SubscriptionFeature> get availableFeatures {
    switch (tier) {
      case SubscriptionTier.free:
        return _freeFeatures;
      case SubscriptionTier.premium:
        return _allFeatures;
      case SubscriptionTier.lifetime:
        return _allFeatures;
    }
  }

  /// Check if a specific feature is available
  bool hasFeature(String featureId) {
    return availableFeatures.any((f) => f.id == featureId);
  }

  /// Get display name for current tier
  String get tierDisplayName {
    switch (tier) {
      case SubscriptionTier.free:
        return isTrialActive ? 'Free Trial' : 'Free';
      case SubscriptionTier.premium:
        return 'Premium';
      case SubscriptionTier.lifetime:
        return 'Lifetime';
    }
  }

  /// Get price information for current tier
  String get priceInfo {
    switch (tier) {
      case SubscriptionTier.free:
        return isTrialActive ? '7 days trial' : 'Free';
      case SubscriptionTier.premium:
        return '\$9.99/month or \$79.99/year';
      case SubscriptionTier.lifetime:
        return '\$149.99 one-time';
    }
  }

  static final List<SubscriptionFeature> _freeFeatures = [
    SubscriptionFeature(
      id: 'motion_detection_basic',
      name: 'Basic Motion Detection',
      description: 'Automatic recording when movement is detected',
      isAvailable: true,
    ),
    SubscriptionFeature(
      id: 'rgb_mode',
      name: 'RGB Camera Mode',
      description: 'Standard color camera view',
      isAvailable: true,
    ),
    SubscriptionFeature(
      id: 'manual_recording',
      name: 'Manual Recording',
      description: 'Up to 5 minutes per session',
      isAvailable: true,
    ),
    SubscriptionFeature(
      id: 'gallery_basic',
      name: 'Local Gallery',
      description: 'Last 5 recordings',
      isAvailable: true,
    ),
    SubscriptionFeature(
      id: 'notifications',
      name: 'Basic Notifications',
      description: 'Motion and recording alerts',
      isAvailable: true,
    ),
  ];

  static final List<SubscriptionFeature> _allFeatures = [
    ..._freeFeatures,
    SubscriptionFeature(
      id: 'infrared_mode',
      name: 'Infrared Mode',
      description: 'Red-channel emphasis for heat-like cues',
      isAvailable: true,
      isPremium: true,
    ),
    SubscriptionFeature(
      id: 'ultraviolet_mode',
      name: 'Ultra Violet Mode',
      description: 'Violet emphasis for atmospheric detail',
      isAvailable: true,
      isPremium: true,
    ),
    SubscriptionFeature(
      id: 'night_vision',
      name: 'Night Vision',
      description: 'Low-light enhancement',
      isAvailable: true,
      isPremium: true,
    ),
    SubscriptionFeature(
      id: 'cmyk_mode',
      name: 'CMYK Mode',
      description: 'Color separation for atypical signatures',
      isAvailable: true,
      isPremium: true,
    ),
    SubscriptionFeature(
      id: 'bw_mode',
      name: 'Black & White Mode',
      description: 'Contrast and luminance emphasis',
      isAvailable: true,
      isPremium: true,
    ),
    SubscriptionFeature(
      id: 'unlimited_recording',
      name: 'Unlimited Recording',
      description: 'No time limits per session',
      isAvailable: true,
      isPremium: true,
    ),
    SubscriptionFeature(
      id: 'external_streams',
      name: 'External Stream Support',
      description: 'HTTP/HTTPS IP camera integration',
      isAvailable: true,
      isPremium: true,
    ),
    SubscriptionFeature(
      id: 'advanced_motion',
      name: 'Advanced Motion Detection',
      description: 'Customizable sensitivity and zone detection',
      isAvailable: true,
      isPremium: true,
    ),
    SubscriptionFeature(
      id: 'unlimited_gallery',
      name: 'Unlimited Gallery',
      description: 'Unlimited recording history',
      isAvailable: true,
      isPremium: true,
    ),
    SubscriptionFeature(
      id: 'priority_support',
      name: 'Priority Support',
      description: 'Email support within 24 hours',
      isAvailable: true,
      isPremium: true,
    ),
  ];

  /// Create a demo/sample subscription for testing
  factory SubscriptionModel.trial() {
    return SubscriptionModel(
      tier: SubscriptionTier.free,
      isActive: true,
      isTrialActive: true,
      trialStartDate: DateTime.now().subtract(const Duration(days: 2)),
      expirationDate: DateTime.now().add(const Duration(days: 5)),
      daysRemaining: 5,
    );
  }

  factory SubscriptionModel.premium() {
    return SubscriptionModel(
      tier: SubscriptionTier.premium,
      isActive: true,
      isTrialActive: false,
      expirationDate: DateTime.now().add(const Duration(days: 30)),
      daysRemaining: 30,
    );
  }

  factory SubscriptionModel.lifetime() {
    return SubscriptionModel(
      tier: SubscriptionTier.lifetime,
      isActive: true,
      isTrialActive: false,
      daysRemaining: -1, // Never expires
    );
  }

  factory SubscriptionModel.free() {
    return SubscriptionModel(
      tier: SubscriptionTier.free,
      isActive: false,
      isTrialActive: false,
      daysRemaining: 0,
    );
  }
}

/// Subscription tier enumeration
enum SubscriptionTier {
  free,
  premium,
  lifetime,
}

/// Individual subscription feature
class SubscriptionFeature {
  final String id;
  final String name;
  final String description;
  final bool isAvailable;
  final bool isPremium;

  SubscriptionFeature({
    required this.id,
    required this.name,
    required this.description,
    this.isAvailable = false,
    this.isPremium = false,
  });
}
