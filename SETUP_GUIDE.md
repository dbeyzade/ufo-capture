# UFO Capture - Kurulum Rehberi

Bu rehber, UFO Capture uygulamasını ve abonelik özellikleri görüntüleme sistemini kurmak için gereken adımları içerir.

## Gereksinimler

### Yazılım Gereksinimleri
- Flutter SDK 3.0.0 veya üstü
- Dart SDK 3.0.0 veya üstü
- Android Studio (Android geliştirme için)
- Xcode (iOS geliştirme için, sadece macOS)
- Git

### Platform Gereksinimleri
- **iOS**: iOS 12.0 veya üstü
- **Android**: Android 6.0 (API 23) veya üstü

## Kurulum Adımları

### 1. Flutter SDK Kurulumu

#### macOS
```bash
cd ~/development
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.16.0-stable.zip
unzip flutter_macos_3.16.0-stable.zip
export PATH="$PATH:`pwd`/flutter/bin"
```

#### Linux
```bash
cd ~/development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz
tar xf flutter_linux_3.16.0-stable.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"
```

#### Windows
1. https://flutter.dev/docs/get-started/install/windows adresinden Flutter SDK'yı indirin
2. ZIP dosyasını çıkarın (örn: C:\src\flutter)
3. PATH ortam değişkenine ekleyin

### 2. Flutter Doğrulama
```bash
flutter doctor
```

Bu komut eksik bağımlılıkları gösterecektir. Tüm sorunları çözün.

### 3. Proje Kurulumu

#### Depoyu Klonlayın
```bash
git clone https://github.com/dbeyzade/ufo-capture.git
cd ufo-capture/ufo_capture_app
```

#### Bağımlılıkları Yükleyin
```bash
flutter pub get
```

### 4. Platform Özel Yapılandırma

#### iOS (sadece macOS)

1. Info.plist dosyasını düzenleyin:
```bash
cd ios/Runner
nano Info.plist
```

2. Aşağıdaki izinleri ekleyin:
```xml
<key>NSCameraUsageDescription</key>
<string>UFO tespiti için kamera erişimi gereklidir</string>
<key>NSMicrophoneUsageDescription</key>
<string>Video kaydı için mikrofon erişimi gereklidir</string>
```

3. CocoaPods bağımlılıklarını yükleyin:
```bash
cd ios
pod install
cd ..
```

#### Android

1. AndroidManifest.xml dosyasını kontrol edin:
```bash
cat android/app/src/main/AndroidManifest.xml
```

2. Gerekli izinlerin mevcut olduğundan emin olun:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### 5. Uygulamayı Çalıştırma

#### Bağlı Cihazları Listele
```bash
flutter devices
```

#### Uygulamayı Başlat
```bash
# Varsayılan cihazda
flutter run

# Belirli bir cihazda
flutter run -d <DEVICE_ID>

# Release modunda
flutter run --release
```

### 6. Testleri Çalıştırma

#### Tüm Testler
```bash
flutter test
```

#### Belirli Bir Test Dosyası
```bash
flutter test test/subscription_model_test.dart
```

#### Test Kapsamı
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Abonelik Özelliklerini Test Etme

### 1. Uygulamayı Başlatın
```bash
flutter run
```

### 2. Ana Ekran
- Uygulama açıldığında ana sayfayı göreceksiniz
- Mevcut abonelik durumu kartı görüntülenecektir

### 3. Abonelik Ekranına Gidin
- "Abonelik Özelliklerimi Göster" butonuna tıklayın
- Abonelik ekranı açılacaktır

### 4. Özellikleri İnceleyin
- Mevcut planınızı görün
- Tüm mevcut özelliklerin listesini kontrol edin
- Premium özellikler "Premium" rozeti ile işaretlenmiştir
- Karşılaştırma tablosunu gözden geçirin

### 5. Yükseltme Test Edin
- "Premium'a Yükselt" butonuna tıklayın
- Plan seçim diyalogu açılacaktır
- Aylık, Yıllık veya Ömür Boyu seçeneklerinden birini seçin
- Abonelik güncellenecek ve UI otomatik yenilenecektir

### 6. Geri Yükleme Test Edin
- "Satın Alımları Geri Yükle" butonuna tıklayın
- Sistem mevcut satın alımları kontrol edecektir

## Debug Modda Çalıştırma

### Hot Reload Kullanımı
Kod değişikliklerinden sonra:
```
# Terminal'de 'r' tuşuna basın
r  # Hot reload
R  # Hot restart
```

### DevTools
```bash
# DevTools'u başlat
flutter pub global activate devtools
flutter pub global run devtools

# Uygulamayı debug modunda çalıştır
flutter run --observatory-port=9200
```

## Sorun Giderme

### Problem: "No devices found"
**Çözüm:**
```bash
# Android
adb devices
# iOS
xcrun simctl list devices

# Emülatör başlat
flutter emulators
flutter emulators --launch <EMULATOR_ID>
```

### Problem: "Gradle build failed"
**Çözüm:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Problem: "CocoaPods not installed"
**Çözüm:**
```bash
sudo gem install cocoapods
pod setup
```

### Problem: "Package not found"
**Çözüm:**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

### Problem: Kamera çalışmıyor
**Çözüm:**
- Fiziksel cihaz kullanın (simulator/emulator kamera desteği sınırlıdır)
- İzinlerin verildiğinden emin olun
- Info.plist (iOS) veya AndroidManifest.xml (Android) izinlerini kontrol edin

## Geliştirme İpuçları

### 1. Kod Formatlama
```bash
dart format .
```

### 2. Kod Analizi
```bash
flutter analyze
```

### 3. Bağımlılık Güncelleme
```bash
flutter pub upgrade
flutter pub outdated
```

### 4. Build Temizleme
```bash
flutter clean
```

### 5. State İnceleme
Debug modunda Provider state'ini incelemek için:
```dart
print(Provider.of<SubscriptionService>(context, listen: false).currentSubscription);
```

## Üretim Build'i

### Android APK
```bash
flutter build apk --release
```

APK konumu: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (Play Store)
```bash
flutter build appbundle --release
```

### iOS (sadece macOS)
```bash
flutter build ios --release
```

Ardından Xcode'da açın ve Archive oluşturun.

## Sonraki Adımlar

1. **Uygulama İçi Satın Alım Entegrasyonu**
   - App Store Connect yapılandırması (iOS)
   - Google Play Console yapılandırması (Android)
   - Gerçek ürün ID'lerini ayarlayın

2. **Analizler Ekleme**
   - Firebase Analytics
   - Abonelik dönüşüm takibi

3. **Push Bildirimleri**
   - Firebase Cloud Messaging
   - Abonelik hatırlatıcıları

4. **Backend Entegrasyonu**
   - Kullanıcı kimlik doğrulama
   - Abonelik doğrulama sunucusu

## Destek

Sorunlar için:
- GitHub Issues: https://github.com/dbeyzade/ufo-capture/issues
- Dokümantasyon: README.md ve SUBSCRIPTION_FEATURES.md dosyalarına bakın

## Lisans

Bu proje LICENSE dosyasında belirtilen şartlar altında lisanslanmıştır.
