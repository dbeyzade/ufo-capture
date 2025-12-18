import 'package:flutter_test/flutter_test.dart';
import 'package:ufo_capture/models/subscription_model.dart';

void main() {
  group('SubscriptionModel Tests', () {
    test('Trial subscription should have correct features', () {
      final subscription = SubscriptionModel.trial();
      
      expect(subscription.tier, SubscriptionTier.free);
      expect(subscription.isTrialActive, true);
      expect(subscription.isActive, true);
      expect(subscription.daysRemaining, 5);
      
      // Check that trial has basic features
      expect(subscription.hasFeature('motion_detection_basic'), true);
      expect(subscription.hasFeature('rgb_mode'), true);
      
      // Check that trial doesn't have premium features
      expect(subscription.hasFeature('infrared_mode'), false);
      expect(subscription.hasFeature('night_vision'), false);
    });

    test('Premium subscription should have all features', () {
      final subscription = SubscriptionModel.premium();
      
      expect(subscription.tier, SubscriptionTier.premium);
      expect(subscription.isTrialActive, false);
      expect(subscription.isActive, true);
      
      // Check that premium has basic features
      expect(subscription.hasFeature('motion_detection_basic'), true);
      expect(subscription.hasFeature('rgb_mode'), true);
      
      // Check that premium has advanced features
      expect(subscription.hasFeature('infrared_mode'), true);
      expect(subscription.hasFeature('night_vision'), true);
      expect(subscription.hasFeature('unlimited_recording'), true);
      expect(subscription.hasFeature('external_streams'), true);
    });

    test('Lifetime subscription should never expire', () {
      final subscription = SubscriptionModel.lifetime();
      
      expect(subscription.tier, SubscriptionTier.lifetime);
      expect(subscription.isActive, true);
      expect(subscription.daysRemaining, -1); // Never expires
      
      // Should have all features
      expect(subscription.hasFeature('infrared_mode'), true);
      expect(subscription.hasFeature('unlimited_recording'), true);
    });

    test('Free subscription should have limited features', () {
      final subscription = SubscriptionModel.free();
      
      expect(subscription.tier, SubscriptionTier.free);
      expect(subscription.isActive, false);
      expect(subscription.isTrialActive, false);
      expect(subscription.daysRemaining, 0);
      
      // Check basic features available
      expect(subscription.hasFeature('motion_detection_basic'), true);
      
      // Check premium features not available
      expect(subscription.hasFeature('infrared_mode'), false);
    });

    test('Tier display names should be correct', () {
      expect(SubscriptionModel.trial().tierDisplayName, 'Free Trial');
      expect(SubscriptionModel.premium().tierDisplayName, 'Premium');
      expect(SubscriptionModel.lifetime().tierDisplayName, 'Lifetime');
      expect(SubscriptionModel.free().tierDisplayName, 'Free');
    });

    test('Price info should be correct', () {
      expect(SubscriptionModel.trial().priceInfo, '7 days trial');
      expect(SubscriptionModel.premium().priceInfo, '\$9.99/month or \$79.99/year');
      expect(SubscriptionModel.lifetime().priceInfo, '\$149.99 one-time');
      expect(SubscriptionModel.free().priceInfo, 'Free');
    });

    test('Available features list should be correct', () {
      final freeSubscription = SubscriptionModel.free();
      final premiumSubscription = SubscriptionModel.premium();
      
      expect(freeSubscription.availableFeatures.length, 5);
      expect(premiumSubscription.availableFeatures.length, 15); // 5 basic + 10 premium
    });
  });

  group('SubscriptionFeature Tests', () {
    test('Feature should have correct properties', () {
      final feature = SubscriptionFeature(
        id: 'test_feature',
        name: 'Test Feature',
        description: 'Test Description',
        isAvailable: true,
        isPremium: true,
      );
      
      expect(feature.id, 'test_feature');
      expect(feature.name, 'Test Feature');
      expect(feature.description, 'Test Description');
      expect(feature.isAvailable, true);
      expect(feature.isPremium, true);
    });

    test('Feature defaults should be correct', () {
      final feature = SubscriptionFeature(
        id: 'test',
        name: 'Test',
        description: 'Test',
      );
      
      expect(feature.isAvailable, false);
      expect(feature.isPremium, false);
    });
  });
}
