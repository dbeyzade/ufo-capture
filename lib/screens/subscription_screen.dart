import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/subscription_service.dart';
import '../models/subscription_model.dart';

/// Screen displaying subscription features, active models, and usage quotas
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SubscriptionService>(context, listen: false)
          .loadSubscription();
    });
  }

  Future<void> _refreshSubscription() async {
    setState(() => _isRefreshing = true);
    await Provider.of<SubscriptionService>(context, listen: false)
        .refreshSubscription();
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abonelik Özellikleri'),
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshSubscription,
          ),
        ],
      ),
      body: Consumer<SubscriptionService>(
        builder: (context, subscriptionService, child) {
          final subscription = subscriptionService.subscription;

          if (subscription == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshSubscription,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlanCard(subscription),
                  const SizedBox(height: 20),
                  _buildModelsCard(subscription),
                  const SizedBox(height: 20),
                  _buildUsageQuotaCard(subscription),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionModel subscription) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final daysRemaining = subscription.expiryDate != null
        ? subscription.expiryDate!.difference(DateTime.now()).inDays
        : null;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.workspace_premium,
                    size: 32, color: Colors.amber),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subscription.planName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Aktif Plan',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(
              'Başlangıç Tarihi',
              dateFormat.format(subscription.startDate),
            ),
            if (subscription.expiryDate != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                'Bitiş Tarihi',
                dateFormat.format(subscription.expiryDate!),
              ),
            ],
            if (daysRemaining != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                'Kalan Süre',
                '$daysRemaining gün',
                valueColor: daysRemaining < 30 ? Colors.orange : Colors.green,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModelsCard(SubscriptionModel subscription) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings, size: 28, color: Colors.blue),
                const SizedBox(width: 12),
                Text(
                  'Kullanılan Modeller',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              '${subscription.activeModels.length} model aktif',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            ...subscription.activeModels.map(
              (model) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        model,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageQuotaCard(SubscriptionModel subscription) {
    final quota = subscription.usageQuota;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, size: 28, color: Colors.purple),
                const SizedBox(width: 12),
                Text(
                  'Kullanım Kotası',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),
            _buildUsageSection(
              'Kayıtlar',
              quota.usedRecordings,
              quota.totalRecordings,
              Icons.videocam,
              'kayıt',
              quota.recordingsPercentage,
            ),
            const SizedBox(height: 24),
            _buildUsageSection(
              'Depolama',
              quota.usedStorageGB,
              quota.totalStorageGB,
              Icons.storage,
              'GB',
              quota.storagePercentage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageSection(
    String title,
    num used,
    num total,
    IconData icon,
    String unit,
    double percentage,
  ) {
    final color = percentage > 80
        ? Colors.red
        : percentage > 60
            ? Colors.orange
            : Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${used.toStringAsFixed(used is double ? 1 : 0)} / ${total.toStringAsFixed(total is double ? 1 : 0)} $unit',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '%${percentage.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 12,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
        ),
      ],
    );
  }
}
