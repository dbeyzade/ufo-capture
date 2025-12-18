# UFO Capture App - Abonelik Özellikleri

Bu dizin, UFO Capture uygulamasının Flutter implementasyonunu içerir ve **abonelik özelliklerini görüntüleme** özelliğini içerir.

## Abonelik Özellikleri Ekranı

### Genel Bakış
Kullanıcılar, uygulamadaki abonelik durumlarını ve mevcut özelliklerini görüntüleyebilirler. Bu özellik, kullanıcılara şunları sağlar:

- Mevcut abonelik planını görüntüleme
- Aktif özelliklerin listesini görme
- Kalan gün sayısını kontrol etme
- Premium planlara yükseltme seçeneği
- Önceki satın alımları geri yükleme

### Dosya Yapısı

```
ufo_capture_app/
├── lib/
│   ├── main.dart                           # Ana uygulama giriş noktası
│   ├── models/
│   │   └── subscription_model.dart         # Abonelik veri modeli
│   ├── services/
│   │   └── subscription_service.dart       # Abonelik yönetim servisi
│   ├── screens/
│   │   └── subscription_screen.dart        # Abonelik ekranı UI
│   └── widgets/                            # Özel widget'lar
├── test/
│   └── subscription_model_test.dart        # Birim testler
└── pubspec.yaml                            # Bağımlılıklar
```

### Kullanım

#### Abonelik Ekranını Açma

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const SubscriptionScreen(),
  ),
);
```

#### Abonelik Durumunu Kontrol Etme

```dart
final subscriptionService = Provider.of<SubscriptionService>(context);
final subscription = subscriptionService.currentSubscription;

if (subscription?.hasFeature('infrared_mode') ?? false) {
  // Kızılötesi modu etkinleştir
}
```

### Özellikler

#### Görsel Bileşenler
1. **Abonelik Başlığı**: Mevcut plan, fiyat ve durum bilgisi
2. **Özellik Listesi**: Tüm mevcut özelliklerin detaylı listesi
3. **Karşılaştırma Tablosu**: Ücretsiz, Premium ve Ömür Boyu planların karşılaştırması
4. **Aksiyon Butonları**: Yükseltme ve geri yükleme seçenekleri

#### Abonelik Seviyeleri
- **Ücretsiz Deneme (7 gün)**
  - Temel hareket algılama
  - RGB kamera modu
  - Manuel kayıt (5 dakika)
  - Son 5 kayıt
  
- **Premium (\$9.99/ay veya \$79.99/yıl)**
  - Tüm ücretsiz özellikler
  - Gelişmiş renk modları (Kızılötesi, UV, Gece Görüşü)
  - Sınırsız kayıt
  - Harici akış desteği
  - Gelişmiş hareket algılama
  - Öncelikli destek
  
- **Ömür Boyu (\$149.99 tek seferlik)**
  - Tüm Premium özellikler
  - Yinelenen ödeme yok
  - Ömür boyu güncelleme
  - Premium teknik destek

### Bağımlılıklar

```yaml
dependencies:
  provider: ^6.1.1            # Durum yönetimi
  shared_preferences: ^2.2.2  # Yerel veri saklama
  intl: ^0.18.1              # Tarih formatlama
  in_app_purchase: ^3.1.11   # Uygulama içi satın alımlar
```

### Kurulum

1. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

2. Testleri çalıştırın:
```bash
flutter test
```

3. Uygulamayı çalıştırın:
```bash
flutter run
```

### Test

Abonelik modeli için birim testler `test/subscription_model_test.dart` dosyasında bulunur.

Testleri çalıştırmak için:
```bash
flutter test test/subscription_model_test.dart
```

Test kapsamı:
- Abonelik seviyelerinin doğru özellikleri içermesi
- Özellik erişim kontrolü
- Deneme süresi hesaplama
- Fiyat bilgisi doğruluğu

### Türkçe Arayüz

Abonelik ekranı tamamen Türkçe dilinde tasarlanmıştır:
- Abonelik Özellikleri (Subscription Features)
- Premium'a Yükselt (Upgrade to Premium)
- Satın Alımları Geri Yükle (Restore Purchases)
- Abonelik Karşılaştırması (Subscription Comparison)

### Gelecek Geliştirmeler

- [ ] Bulut yedekleme entegrasyonu
- [ ] Çoklu akış izleme
- [ ] Sosyal paylaşım özellikleri
- [ ] Gelişmiş analitik ve raporlama
- [ ] Kullanıcı özelleştirilebilir bildirimler

### Lisans

Bu proje, üst düzey LICENSE dosyasında belirtilen şartlar altında lisanslanmıştır.
