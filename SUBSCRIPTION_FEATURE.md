# Abonelik Özellikleri / Subscription Features

## Özellik Açıklaması / Feature Description

Bu özellik, kullanıcının abonelik bilgilerini, kullandığı modelleri ve kullanım kotasını gösterir.

This feature displays the user's subscription information, models being used, and usage quotas.

## Ekran Görünümleri / Screens

### Ana Ekran / Home Screen
Ana ekranda "Abonelik Özelliklerini Göster" butonu bulunur.

The home screen contains a button "Show Subscription Features".

### Abonelik Ekranı / Subscription Screen
Abonelik ekranı üç ana bölümden oluşur:

The subscription screen consists of three main sections:

1. **Plan Bilgileri / Plan Information**
   - Plan adı / Plan name
   - Başlangıç tarihi / Start date
   - Bitiş tarihi / End date
   - Kalan süre (gün) / Remaining time (days)

2. **Kullanılan Modeller / Active Models**
   - RGB Capture
   - Infrared Detection
   - Night Vision
   - Motion Detection
   - Ultra Violet Filter

3. **Kullanım Kotası / Usage Quota**
   - Kayıtlar: Kullanılan/Toplam kayıt sayısı ve yüzde
   - Depolama: Kullanılan/Toplam depolama (GB) ve yüzde

   - Recordings: Used/Total recordings count and percentage
   - Storage: Used/Total storage (GB) and percentage

## Teknik Detaylar / Technical Details

### Dosya Yapısı / File Structure

```
lib/
├── main.dart                               # Ana uygulama / Main app
├── models/
│   └── subscription_model.dart             # Abonelik veri modelleri / Subscription data models
├── services/
│   └── subscription_service.dart           # Abonelik servisi / Subscription service
└── screens/
    └── subscription_screen.dart            # Abonelik ekranı UI / Subscription screen UI
```

### Kullanılan Paketler / Packages Used

- `provider`: State yönetimi / State management
- `intl`: Tarih formatlama / Date formatting

### Özellikler / Features

1. **Yenileme / Refresh**: 
   - Aşağı çekerek yenileme / Pull-to-refresh
   - AppBar'da yenileme butonu / Refresh button in AppBar

2. **Görsel Göstergeler / Visual Indicators**:
   - Kullanım kotası için renkli progress bar'lar / Colored progress bars for usage quotas
   - Kalan süreye göre renk kodlaması (yeşil/turuncu) / Color coding based on remaining time (green/orange)
   - Kullanım yüzdesine göre renk kodlaması (yeşil/turuncu/kırmızı) / Color coding based on usage percentage (green/orange/red)

3. **Türkçe Dil Desteği / Turkish Language Support**:
   - Tüm UI metinleri Türkçe / All UI texts in Turkish

## Kullanım / Usage

1. Uygulamayı başlatın / Start the application
2. Ana ekranda "Abonelik Özelliklerini Göster" butonuna tıklayın / Click the "Show Subscription Features" button on the home screen
3. Abonelik bilgilerinizi görüntüleyin / View your subscription information
4. Yenilemek için aşağı çekin veya yenile butonuna basın / Pull down or press the refresh button to update

## Gelecek Geliştirmeler / Future Improvements

- API entegrasyonu / API integration
- Gerçek zamanlı kullanım takibi / Real-time usage tracking
- Abonelik yükseltme/düşürme özellikleri / Subscription upgrade/downgrade features
- Bildirim sistemi (kota dolduğunda) / Notification system (when quota is full)
- Detaylı kullanım raporları / Detailed usage reports
