import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/subscription_model.dart';
import '../services/subscription_service.dart';

/// Screen to display subscription features and status
class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abonelik Özellikleri'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Consumer<SubscriptionService>(
        builder: (context, subscriptionService, child) {
          final subscription = subscriptionService.currentSubscription;

          if (subscription == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSubscriptionHeader(subscription),
                const Divider(height: 1),
                _buildFeaturesList(subscription),
                _buildActionButtons(context, subscription, subscriptionService),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build subscription status header
  Widget _buildSubscriptionHeader(SubscriptionModel subscription) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getGradientColors(subscription.tier),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Icon(
            _getTierIcon(subscription.tier),
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            subscription.tierDisplayName,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subscription.priceInfo,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatusBadge(subscription),
        ],
      ),
    );
  }

  /// Build status badge showing expiration or trial info
  Widget _buildStatusBadge(SubscriptionModel subscription) {
    String statusText;
    Color badgeColor;

    if (subscription.tier == SubscriptionTier.lifetime) {
      statusText = 'Ömür Boyu Aktif';
      badgeColor = Colors.green;
    } else if (subscription.isTrialActive) {
      statusText = '${subscription.daysRemaining} gün deneme süresi kaldı';
      badgeColor = Colors.orange;
    } else if (subscription.isActive) {
      statusText = '${subscription.daysRemaining} gün kaldı';
      badgeColor = Colors.blue;
    } else {
      statusText = 'Aktif Değil';
      badgeColor = Colors.red;
    }

    if (subscription.expirationDate != null) {
      final dateStr = DateFormat('dd/MM/yyyy').format(subscription.expirationDate!);
      statusText += '\nBitiş: $dateStr';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Build list of features
  Widget _buildFeaturesList(SubscriptionModel subscription) {
    final allFeatures = subscription.availableFeatures;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Özellikler',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...allFeatures.map((feature) => _buildFeatureItem(feature)),
        ],
      ),
    );
  }

  /// Build individual feature item
  Widget _buildFeatureItem(SubscriptionFeature feature) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: feature.isAvailable
              ? (feature.isPremium ? Colors.amber : Colors.green)
              : Colors.grey,
          child: Icon(
            feature.isAvailable ? Icons.check : Icons.lock,
            color: Colors.white,
          ),
        ),
        title: Text(
          feature.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(feature.description),
        trailing: feature.isPremium
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Premium',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  /// Build action buttons for subscription management
  Widget _buildActionButtons(
    BuildContext context,
    SubscriptionModel subscription,
    SubscriptionService subscriptionService,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (subscription.tier != SubscriptionTier.lifetime) ...[
            if (subscription.tier == SubscriptionTier.free)
              ElevatedButton(
                onPressed: () => _showUpgradeDialog(context, subscriptionService),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Premium\'a Yükselt',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            const SizedBox(height: 12),
          ],
          OutlinedButton(
            onPressed: () => _restorePurchases(context, subscriptionService),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Satın Alımları Geri Yükle',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 24),
          _buildComparisonTable(),
        ],
      ),
    );
  }

  /// Build comparison table for subscription tiers
  Widget _buildComparisonTable() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Abonelik Karşılaştırması',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildComparisonRow('Hareket Algılama', true, true, true),
            _buildComparisonRow('RGB Modu', true, true, true),
            _buildComparisonRow('Gelişmiş Renkler', false, true, true),
            _buildComparisonRow('Sınırsız Kayıt', false, true, true),
            _buildComparisonRow('Harici Akış', false, true, true),
            _buildComparisonRow('Öncelikli Destek', false, true, true),
            const Divider(),
            _buildComparisonRow('Fiyat', null, null, null,
                customValues: ['Ücretsiz', '\$9.99/ay', '\$149.99']),
          ],
        ),
      ),
    );
  }

  /// Build individual comparison row
  Widget _buildComparisonRow(
    String feature,
    bool? free,
    bool? premium,
    bool? lifetime, {
    List<String>? customValues,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              feature,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: _buildComparisonCell(free, customValues?[0]),
          ),
          Expanded(
            child: _buildComparisonCell(premium, customValues?[1]),
          ),
          Expanded(
            child: _buildComparisonCell(lifetime, customValues?[2]),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCell(bool? value, String? customValue) {
    if (customValue != null) {
      return Text(
        customValue,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      );
    }
    return Icon(
      value == true ? Icons.check_circle : Icons.cancel,
      color: value == true ? Colors.green : Colors.grey,
      size: 20,
    );
  }

  /// Show upgrade dialog
  void _showUpgradeDialog(BuildContext context, SubscriptionService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium\'a Yükselt'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Hangi planı seçmek istersiniz?'),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Aylık'),
              subtitle: const Text('\$9.99/ay'),
              onTap: () {
                service.upgradeToPremium(isYearly: false);
                Navigator.pop(context);
                _showSuccessMessage(context);
              },
            ),
            ListTile(
              title: const Text('Yıllık'),
              subtitle: const Text('\$79.99/yıl (2 ay bedava)'),
              onTap: () {
                service.upgradeToPremium(isYearly: true);
                Navigator.pop(context);
                _showSuccessMessage(context);
              },
            ),
            ListTile(
              title: const Text('Ömür Boyu'),
              subtitle: const Text('\$149.99 (tek seferlik)'),
              onTap: () {
                service.upgradeToLifetime();
                Navigator.pop(context);
                _showSuccessMessage(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
        ],
      ),
    );
  }

  /// Restore purchases
  void _restorePurchases(BuildContext context, SubscriptionService service) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final success = await service.restorePurchases();
    
    if (context.mounted) {
      Navigator.pop(context); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Satın alımlar başarıyla geri yüklendi'
                : 'Geri yüklenecek satın alım bulunamadı',
          ),
          backgroundColor: success ? Colors.green : Colors.orange,
        ),
      );
    }
  }

  /// Show success message
  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abonelik başarıyla güncellendi!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Get gradient colors based on tier
  List<Color> _getGradientColors(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return [Colors.grey.shade600, Colors.grey.shade800];
      case SubscriptionTier.premium:
        return [Colors.deepPurple, Colors.purple.shade700];
      case SubscriptionTier.lifetime:
        return [Colors.amber.shade700, Colors.orange.shade700];
    }
  }

  /// Get icon based on tier
  IconData _getTierIcon(SubscriptionTier tier) {
    switch (tier) {
      case SubscriptionTier.free:
        return Icons.star_border;
      case SubscriptionTier.premium:
        return Icons.star;
      case SubscriptionTier.lifetime:
        return Icons.workspace_premium;
    }
  }
}
