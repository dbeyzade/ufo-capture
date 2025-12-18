/// Model representing user's subscription information
class SubscriptionModel {
  final String planName;
  final List<String> activeModels;
  final UsageQuota usageQuota;
  final DateTime startDate;
  final DateTime? expiryDate;

  SubscriptionModel({
    required this.planName,
    required this.activeModels,
    required this.usageQuota,
    required this.startDate,
    this.expiryDate,
  });
}

/// Model representing usage quota information
class UsageQuota {
  final int totalRecordings;
  final int usedRecordings;
  final double totalStorageGB;
  final double usedStorageGB;

  UsageQuota({
    required this.totalRecordings,
    required this.usedRecordings,
    required this.totalStorageGB,
    required this.usedStorageGB,
  });

  double get recordingsPercentage =>
      totalRecordings > 0 ? (usedRecordings / totalRecordings) * 100 : 0;

  double get storagePercentage =>
      totalStorageGB > 0 ? (usedStorageGB / totalStorageGB) * 100 : 0;
}
