# Screen Layouts - Visual Guide

## Home Screen (Ana Ekran)

```
┌─────────────────────────────────────┐
│  UFO Capture                        │
├─────────────────────────────────────┤
│                                     │
│                                     │
│           📷                        │
│       (Camera Icon)                 │
│                                     │
│      UFO Capture App                │
│                                     │
│   Gökyüzünü izleyin, hareketi      │
│   algılayın ve anomalileri          │
│   otomatik olarak kaydedin          │
│                                     │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ 👑 Abonelik Özelliklerini    │ │
│  │    Göster                     │ │
│  └───────────────────────────────┘ │
│                                     │
└─────────────────────────────────────┘
```

## Subscription Screen (Abonelik Ekranı)

```
┌─────────────────────────────────────┐
│ ← Abonelik Özellikleri         🔄  │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │ 👑  Premium Plan            │   │
│  │     Aktif Plan              │   │
│  │ ─────────────────────────── │   │
│  │ Başlangıç Tarihi: 03/11/2024│  │
│  │ Bitiş Tarihi:     03/11/2025│   │
│  │ Kalan Süre:       320 gün   │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ⚙️  Kullanılan Modeller     │   │
│  │ ─────────────────────────── │   │
│  │ 5 model aktif               │   │
│  │                             │   │
│  │ ✓ RGB Capture               │   │
│  │ ✓ Infrared Detection        │   │
│  │ ✓ Night Vision              │   │
│  │ ✓ Motion Detection          │   │
│  │ ✓ Ultra Violet Filter       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📊  Kullanım Kotası         │   │
│  │ ─────────────────────────── │   │
│  │ 📹 Kayıtlar                 │   │
│  │ 347 / 1000 kayıt      34.7% │   │
│  │ ▓▓▓▓▓▓▓░░░░░░░░░░░░░        │   │
│  │                             │   │
│  │ 💾 Depolama                 │   │
│  │ 23.5 / 50.0 GB        47.0% │   │
│  │ ▓▓▓▓▓▓▓▓▓░░░░░░░░░░░        │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

## Color Coding

### Progress Bars
- **Green** (0-60%): ▓▓▓░░░░░░░ Normal usage
- **Orange** (60-80%): ▓▓▓▓▓▓▓░░░ Warning
- **Red** (80-100%): ▓▓▓▓▓▓▓▓▓▓ Critical

### Days Remaining
- **Green**: > 30 days remaining
- **Orange**: < 30 days remaining

## Interactive Elements

### Home Screen
1. **"Abonelik Özelliklerini Göster" Button**
   - Tapping navigates to Subscription Screen
   - Material Design elevated button with icon

### Subscription Screen
1. **Refresh Button (AppBar)**
   - Icon button in top-right
   - Shows loading indicator when refreshing
   
2. **Pull-to-Refresh**
   - Pull down gesture anywhere on screen
   - Shows circular progress indicator
   - Refreshes subscription data

3. **Back Button (AppBar)**
   - Returns to Home Screen

## Card Components

### 1. Plan Card (Top)
- **Header**: Crown icon + Plan name
- **Content**: 
  - Start date with label
  - End date with label
  - Days remaining with color coding
- **Styling**: White background, shadow elevation 4

### 2. Models Card (Middle)
- **Header**: Settings icon + "Kullanılan Modeller"
- **Subheader**: Model count
- **Content**: List of models with checkmarks
- **Styling**: White background, shadow elevation 4

### 3. Usage Quota Card (Bottom)
- **Header**: Analytics icon + "Kullanım Kotası"
- **Content**: Two sections (Recordings & Storage)
  - Icon + label
  - Used/Total values
  - Percentage
  - Color-coded progress bar
- **Styling**: White background, shadow elevation 4

## Typography

- **Headers (Card Titles)**: TitleLarge (22-24sp)
- **Subheaders**: TitleMedium (16-18sp)
- **Body Text**: BodyLarge (16sp)
- **Labels**: BodyMedium (14sp)
- **Small Text**: BodySmall (12sp)

## Spacing

- **Card Padding**: 16dp all sides
- **Between Cards**: 20dp vertical
- **Screen Padding**: 16dp all sides
- **Icon-to-Text**: 8-12dp horizontal
- **Section Spacing**: 16-24dp vertical

## Icons

- 👑 Premium Plan: `Icons.workspace_premium`
- ⚙️ Models: `Icons.settings`
- 📊 Analytics: `Icons.analytics`
- 📹 Video: `Icons.videocam`
- 💾 Storage: `Icons.storage`
- ✓ Checkmark: `Icons.check_circle`
- 🔄 Refresh: `Icons.refresh`
- 📷 Camera: `Icons.camera_alt`

## States

### Loading State
```
┌─────────────────────────────────────┐
│ ← Abonelik Özellikleri         🔄  │
├─────────────────────────────────────┤
│                                     │
│                                     │
│            ⟳                       │
│      (Loading Spinner)              │
│                                     │
│                                     │
└─────────────────────────────────────┘
```

### Refreshing State
```
┌─────────────────────────────────────┐
│ ← Abonelik Özellikleri         ⟳   │
├─────────────────────────────────────┤
│  ↓ Pull to refresh indicator        │
│                                     │
│  [Subscription data displayed]      │
│                                     │
└─────────────────────────────────────┘
```

## Responsive Design

- Single column layout for all screen sizes
- Scrollable when content exceeds viewport
- Cards expand to screen width minus padding
- Text wraps appropriately
- Minimum touch target size: 48dp

## Accessibility

- Semantic labels for screen readers
- High contrast color scheme
- Clear visual hierarchy
- Readable font sizes (minimum 14sp)
- Color is not the only indicator (icons + text labels)
