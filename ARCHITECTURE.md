# UFO Capture - Architecture Overview

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        UFO Capture App                          │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                          Presentation Layer                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────────────┐   │
│  │   Home      │  │  Settings   │  │   Subscription       │   │
│  │   Screen    │  │   Screen    │  │   Screen             │   │
│  │             │  │             │  │  (Turkish UI)        │   │
│  └─────────────┘  └─────────────┘  └──────────────────────┘   │
│                                                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌──────────────────────┐   │
│  │  Camera     │  │   Gallery   │  │   Intro Video        │   │
│  │  Screen     │  │   Screen    │  │   Screen             │   │
│  └─────────────┘  └─────────────┘  └──────────────────────┘   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Business Logic Layer                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────────┐        ┌─────────────────────────┐   │
│  │  Subscription        │◄───────┤  Provider State         │   │
│  │  Service             │        │  Management             │   │
│  │  - State management  │        └─────────────────────────┘   │
│  │  - Feature checks    │                                       │
│  │  - Upgrade logic     │        ┌─────────────────────────┐   │
│  │  - Persistence       │◄───────┤  Subscription Model     │   │
│  └──────────────────────┘        │  - Tiers                │   │
│                                   │  - Features             │   │
│  ┌──────────────────────┐        │  - Pricing              │   │
│  │  Motion Detection    │        └─────────────────────────┘   │
│  │  Service             │                                       │
│  │  - Track movement    │                                       │
│  │  - Trigger recording │                                       │
│  └──────────────────────┘                                       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                          Data Layer                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────────┐        ┌─────────────────────────┐   │
│  │  SharedPreferences   │        │  Local File System      │   │
│  │  - Subscription tier │        │  - Video recordings     │   │
│  │  - Trial dates       │        │  - Gallery storage      │   │
│  │  - Expiration dates  │        │  - Cached assets        │   │
│  └──────────────────────┘        └─────────────────────────┘   │
│                                                                  │
│  ┌──────────────────────┐        ┌─────────────────────────┐   │
│  │  In-App Purchase     │        │  Camera/Hardware        │   │
│  │  - StoreKit (iOS)    │        │  - Device camera        │   │
│  │  - Play Billing (And)│        │  - Microphone           │   │
│  └──────────────────────┘        └─────────────────────────┘   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Subscription Feature Flow

```
                    ┌───────────────────┐
                    │   App Launch      │
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │  Initialize       │
                    │  Subscription     │
                    │  Service          │
                    └─────────┬─────────┘
                              │
                              ▼
                    ┌───────────────────┐
                    │  Load Saved       │
                    │  Subscription     │
                    │  from Storage     │
                    └─────────┬─────────┘
                              │
                    ┌─────────┴─────────┐
                    │                   │
        ┌───────────▼─────────┐    ┌───▼───────────────┐
        │  Existing            │    │  No Subscription  │
        │  Subscription        │    │  Found            │
        └───────────┬─────────┘    └───┬───────────────┘
                    │                   │
                    │                   ▼
                    │          ┌─────────────────────┐
                    │          │  Start Free Trial   │
                    │          │  (7 days)           │
                    │          └───┬─────────────────┘
                    │              │
                    └──────────────┴──────────────────┐
                                                       │
                                                       ▼
                                            ┌──────────────────┐
                                            │  User Navigates  │
                                            │  to Subscription │
                                            │  Screen          │
                                            └────────┬─────────┘
                                                     │
                ┌────────────────────────────────────┴─────┐
                │                                          │
    ┌───────────▼─────────┐                    ┌──────────▼──────────┐
    │  View Features      │                    │  Upgrade to         │
    │  & Status           │                    │  Premium            │
    └─────────────────────┘                    └──────────┬──────────┘
                                                          │
                                            ┌─────────────┴────────────┐
                                            │                          │
                                ┌───────────▼─────────┐   ┌───────────▼────────┐
                                │  Monthly            │   │  Yearly / Lifetime │
                                │  $9.99/mo           │   │  $79.99 / $149.99  │
                                └───────────┬─────────┘   └───────────┬────────┘
                                            │                         │
                                            └─────────────┬───────────┘
                                                          │
                                                          ▼
                                            ┌──────────────────────┐
                                            │  Update Subscription │
                                            │  & Save to Storage   │
                                            └──────────┬───────────┘
                                                       │
                                                       ▼
                                            ┌──────────────────────┐
                                            │  Unlock Premium      │
                                            │  Features            │
                                            └──────────────────────┘
```

## Subscription Model Structure

```
┌─────────────────────────────────────────────────────────┐
│               SubscriptionModel                         │
├─────────────────────────────────────────────────────────┤
│  - tier: SubscriptionTier                               │
│  - expirationDate: DateTime?                            │
│  - isActive: bool                                       │
│  - isTrialActive: bool                                  │
│  - trialStartDate: DateTime?                            │
│  - daysRemaining: int                                   │
├─────────────────────────────────────────────────────────┤
│  + availableFeatures: List<SubscriptionFeature>         │
│  + hasFeature(featureId): bool                          │
│  + tierDisplayName: String                              │
│  + priceInfo: String                                    │
└─────────────────────────────────────────────────────────┘
                        │
                        ├── Uses
                        │
                        ▼
┌─────────────────────────────────────────────────────────┐
│              SubscriptionFeature                        │
├─────────────────────────────────────────────────────────┤
│  - id: String                                           │
│  - name: String                                         │
│  - description: String                                  │
│  - isAvailable: bool                                    │
│  - isPremium: bool                                      │
└─────────────────────────────────────────────────────────┘
```

## Feature Access Control

```
┌──────────────────────────────────────────────────────────────┐
│                    User Action                               │
│           (e.g., Enable Infrared Mode)                       │
└────────────────────────┬─────────────────────────────────────┘
                         │
                         ▼
         ┌───────────────────────────────┐
         │  Check Feature Availability   │
         │  hasFeature('infrared_mode')  │
         └────────────┬──────────────────┘
                      │
        ┌─────────────┴─────────────┐
        │                           │
    ┌───▼─────┐                ┌────▼────┐
    │ Premium │                │  Free   │
    │ Active  │                │  Tier   │
    └───┬─────┘                └────┬────┘
        │                           │
        ▼                           ▼
┌────────────────┐          ┌────────────────┐
│  Grant Access  │          │  Show Premium  │
│  to Feature    │          │  Required      │
│                │          │  Dialog        │
└────────────────┘          └────────────────┘
```

## State Management Flow

```
┌──────────────────────────────────────────────────────────┐
│                  SubscriptionService                     │
│                (ChangeNotifier)                          │
└────────────────────────┬─────────────────────────────────┘
                         │
                         │ notifyListeners()
                         │
         ┌───────────────┴──────────────┐
         │                              │
         ▼                              ▼
┌─────────────────┐            ┌────────────────────┐
│  Subscription   │            │   Home Screen      │
│  Screen         │            │   (Status Card)    │
│  (Full Details) │            └────────────────────┘
└─────────────────┘
         │
         │ User Action
         │ (Upgrade)
         ▼
┌─────────────────────┐
│  Update Service     │
│  - upgradeToPremium │
│  - Save to Storage  │
└──────────┬──────────┘
           │
           │ notifyListeners()
           │
           ▼
    ┌────────────┐
    │  UI Auto   │
    │  Updates   │
    └────────────┘
```

## Data Persistence

```
┌───────────────────────────────────────────────────┐
│          SharedPreferences Storage                │
├───────────────────────────────────────────────────┤
│                                                   │
│  Key: "subscription_tier"                         │
│  Value: 0 (Free), 1 (Premium), 2 (Lifetime)       │
│                                                   │
│  Key: "trial_start_date"                          │
│  Value: Unix timestamp (milliseconds)             │
│                                                   │
│  Key: "premium_expiration_date"                   │
│  Value: Unix timestamp (milliseconds)             │
│                                                   │
└───────────────────────────────────────────────────┘
```

## Screen Navigation

```
┌────────────────┐
│   Home Screen  │
└────────┬───────┘
         │
         │ Button: "Abonelik Özelliklerimi Göster"
         │
         ▼
┌────────────────────┐
│  Subscription      │
│  Screen            │
├────────────────────┤
│  - Header Card     │
│  - Feature List    │
│  - Comparison      │
│  - Action Buttons  │
└────────┬───────────┘
         │
         │ Tap "Premium'a Yükselt"
         │
         ▼
┌────────────────────┐
│  Upgrade Dialog    │
├────────────────────┤
│  □ Monthly         │
│  □ Yearly          │
│  □ Lifetime        │
└────────────────────┘
```

## Technology Stack

```
┌─────────────────────────────────────────┐
│           Frontend (Flutter)            │
├─────────────────────────────────────────┤
│  - Dart 3.0+                            │
│  - Material Design 3                    │
│  - Provider (State Management)          │
│  - Turkish Language UI                  │
└─────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│         State Management                │
├─────────────────────────────────────────┤
│  - Provider Pattern                     │
│  - ChangeNotifier                       │
│  - Consumer Widgets                     │
└─────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│         Local Storage                   │
├─────────────────────────────────────────┤
│  - SharedPreferences                    │
│  - Key-Value Storage                    │
│  - Persistent Subscription State        │
└─────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│      Platform Integration               │
├─────────────────────────────────────────┤
│  - In-App Purchase (iOS/Android)        │
│  - Camera Hardware Access               │
│  - File System (Video Storage)          │
└─────────────────────────────────────────┘
```

## Testing Strategy

```
┌────────────────────────────────────────────┐
│              Unit Tests                    │
├────────────────────────────────────────────┤
│  - SubscriptionModel                       │
│  - SubscriptionFeature                     │
│  - Tier Logic                              │
│  - Feature Access                          │
│  Coverage: 100% of models                  │
└────────────────────────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────┐
│           Integration Tests                │
├────────────────────────────────────────────┤
│  - SubscriptionService                     │
│  - State Persistence                       │
│  - Provider Updates                        │
│  (Future implementation)                   │
└────────────────────────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────┐
│              Widget Tests                  │
├────────────────────────────────────────────┤
│  - SubscriptionScreen UI                   │
│  - User Interactions                       │
│  - Navigation                              │
│  (Future implementation)                   │
└────────────────────────────────────────────┘
```

## Deployment Architecture

```
┌───────────────────────────────────────────────┐
│              iOS Deployment                   │
├───────────────────────────────────────────────┤
│  - App Store                                  │
│  - StoreKit (In-App Purchase)                 │
│  - Subscription Management                    │
│  - TestFlight (Beta Testing)                  │
└───────────────────────────────────────────────┘

┌───────────────────────────────────────────────┐
│            Android Deployment                 │
├───────────────────────────────────────────────┤
│  - Google Play Store                          │
│  - Play Billing (In-App Purchase)             │
│  - Subscription Management                    │
│  - Internal Testing Track                     │
└───────────────────────────────────────────────┘
```

## Security Considerations

```
┌──────────────────────────────────────────────┐
│         Client-Side Validation               │
├──────────────────────────────────────────────┤
│  ✓ Feature access checks                     │
│  ✓ Expiration date validation                │
│  ✓ Trial period enforcement                  │
└──────────────────────────────────────────────┘
                    │
                    ▼
┌──────────────────────────────────────────────┐
│      Server-Side Validation (Future)         │
├──────────────────────────────────────────────┤
│  □ Receipt verification                      │
│  □ Subscription status sync                  │
│  □ Anti-fraud measures                       │
└──────────────────────────────────────────────┘
```

This architecture provides a clean, maintainable, and scalable foundation for the UFO Capture app's subscription system.
