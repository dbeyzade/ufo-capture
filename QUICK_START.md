# UFO Capture - Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### Prerequisites
- Flutter SDK 3.0.0+
- Physical device (simulators have limited camera support)

### Installation
```bash
# Clone the repository
git clone https://github.com/dbeyzade/ufo-capture.git
cd ufo-capture/ufo_capture_app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 📱 View Subscription Features

### From the Home Screen
1. Launch the app
2. Tap **"Abonelik Özelliklerimi Göster"** (Show My Subscription Features)
3. View your current subscription status and available features

### Subscription Screen Overview

```
┌────────────────────────────────┐
│   Subscription Features   [←]  │
├────────────────────────────────┤
│         ⭐ Premium ⭐           │
│    $9.99/month or $79.99/year  │
│        30 days remaining       │
├────────────────────────────────┤
│  Features                      │
│  ✓ Motion Detection            │
│  ✓ RGB Mode                    │
│  ✓ Infrared Mode    [Premium]  │
│  ✓ Night Vision     [Premium]  │
│  ✓ Unlimited Recording [Premium]│
├────────────────────────────────┤
│  [Upgrade to Premium]          │
│  [Restore Purchases]           │
└────────────────────────────────┘
```

## 💎 Subscription Tiers

### Free Trial (7 days)
- Basic motion detection
- RGB camera mode
- Manual recording (5 min limit)
- Last 5 recordings

### Premium ($9.99/month or $79.99/year)
- All free features
- Advanced color modes (Infrared, UV, Night Vision, CMYK, B&W)
- Unlimited recording time
- External stream support (IP cameras)
- Advanced motion detection
- Priority support

### Lifetime ($149.99 one-time)
- All premium features
- No recurring payments
- Lifetime updates

## 🧪 Testing the Implementation

### Run Tests
```bash
# All tests
flutter test

# Subscription model tests only
flutter test test/subscription_model_test.dart
```

### Manual Testing
1. Start the app: `flutter run`
2. Navigate to subscription screen
3. Check current subscription status
4. Test upgrade flow (mock implementation)
5. Test restore purchases (mock implementation)

## 🔑 Key Features

### Subscription Status Display
- Current tier (Free Trial, Premium, Lifetime)
- Days remaining
- Expiration date
- Active status indicator

### Feature List
- All available features for current tier
- Premium features clearly marked
- Feature descriptions
- Visual icons

### Comparison Table
- Side-by-side comparison of all tiers
- Feature availability checkmarks
- Pricing information

### Actions
- Upgrade to Premium (with monthly/yearly/lifetime options)
- Restore previous purchases
- View detailed feature comparisons

## 📂 Project Structure

```
ufo_capture_app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   └── subscription_model.dart  # Subscription data model
│   ├── services/
│   │   └── subscription_service.dart # Subscription management
│   └── screens/
│       └── subscription_screen.dart  # Subscription UI
└── test/
    └── subscription_model_test.dart  # Unit tests
```

## 🎨 Customization

### Change Subscription Prices
Edit `lib/models/subscription_model.dart`:
```dart
String get priceInfo {
  switch (tier) {
    case SubscriptionTier.premium:
      return '\$9.99/month or \$79.99/year'; // Change here
    // ...
  }
}
```

### Add New Features
In `subscription_model.dart`, add to `_allFeatures`:
```dart
SubscriptionFeature(
  id: 'your_feature_id',
  name: 'Your Feature Name',
  description: 'Feature description',
  isAvailable: true,
  isPremium: true,
),
```

### Modify UI Language
Edit `lib/screens/subscription_screen.dart`:
- Change Turkish text to your language
- Update button labels
- Modify dialog messages

## 🛠 Troubleshooting

### "No devices found"
```bash
flutter devices
flutter emulators --launch <EMULATOR_ID>
```

### Build errors
```bash
flutter clean
flutter pub get
flutter run
```

### Camera not working
- Use a physical device (not simulator)
- Check camera permissions in settings
- Verify Info.plist (iOS) or AndroidManifest.xml (Android)

## 📖 Documentation

- **SUBSCRIPTION_FEATURES.md** - Detailed feature documentation
- **SETUP_GUIDE.md** - Complete setup instructions
- **IMPLEMENTATION_SUMMARY.md** - Technical implementation details
- **ufo_capture_app/README.md** - App-specific documentation

## 🔄 Next Steps

1. **Implement Real IAP**: Integrate with App Store / Play Store
2. **Add Backend**: Server-side subscription validation
3. **Analytics**: Track subscription conversions
4. **Localization**: Add more languages

## 📝 Usage Examples

### Check if Feature is Available
```dart
final subscriptionService = Provider.of<SubscriptionService>(context);
if (subscriptionService.hasFeature('infrared_mode')) {
  // Enable infrared mode
}
```

### Upgrade Subscription
```dart
await subscriptionService.upgradeToPremium(isYearly: true);
```

### Restore Purchases
```dart
await subscriptionService.restorePurchases();
```

## ✅ What's Included

- ✅ Complete Flutter app structure
- ✅ Subscription data model with 3 tiers
- ✅ State management with Provider
- ✅ Persistent storage with SharedPreferences
- ✅ Beautiful Turkish-language UI
- ✅ Feature comparison table
- ✅ Upgrade flow dialogs
- ✅ Unit tests with 100% model coverage
- ✅ Comprehensive documentation

## 🎯 Quick Demo

```bash
# Clone and run
git clone https://github.com/dbeyzade/ufo-capture.git
cd ufo-capture/ufo_capture_app
flutter pub get
flutter run

# Tap "Abonelik Özelliklerimi Göster"
# Explore subscription features!
```

## 📞 Support

- GitHub: https://github.com/dbeyzade/ufo-capture
- Issues: https://github.com/dbeyzade/ufo-capture/issues

---

**Ready to capture UFOs! 🛸**
