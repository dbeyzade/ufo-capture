# Ufo Capture

Sky observation recorder: phone or USB external camera, motion detection, 5s countdown.

## Features
- Phone camera recording with adjustable zoom and focus
- External camera/telescope via USB or ip adress : auto‑discover stream URLs (RTSP/HTTP)
- Motion detection: auto start/stop recording on activity
- Manual recording with 5‑second countdown to reduce shake
- On‑device gallery for replay and sharing
- Audio alerts on motion
- Simple licensing: 10 free opens, then one‑time purchase to unlock

## Requirements
- Flutter SDK (stable)
- iOS: Xcode, CocoaPods
- Android: Android SDK (optional)

## Permissions
- Camera, Microphone, Bluetooth (BLE) ,usb connection

## Getting Started
```bash
flutter pub get
flutter run -d ios
```

## Build (iOS)
```bash
flutter build ios --release
# open ios/Runner.xcworkspace → Product → Archive → Distribute
```

## Licensing (Paywall)
- 10 free opens → paywall → one‑time unlock (`ufo_capture_unlock`)

## Support & Links
- Issues: https://github.com/dogukanbeyzade/ufo-capture/issues
- Repo: https://github.com/dogukanbeyzade/ufo-capture
- (Optional) Website: https://dogukanbeyzade.github.io/ufo-capture/
- (Optional) Privacy: https://dogukanbeyzade.github.io/ufo-capture/privacy.html

## License
MIT
