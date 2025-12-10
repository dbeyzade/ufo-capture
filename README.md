UFO Capture App

Monitor the sky, detect motion, and automatically record anomalies — even beyond what the human eye can see. Human vision typically covers the 400–700 nm spectrum; it cannot perceive infrared (beyond red) or ultraviolet (beyond violet). UFO Capture enhances visibility with specialized modes and filters, helping you record the details the eye often misses.

Features

- Real‑time motion detection with on‑screen tracking overlay
- Auto start/stop recording triggered by activity
- Color modes: RGB, Black & White, Infrared, Ultra Violet, Night Vision, CMYK
- Manual controls: pinch‑to‑zoom, tap‑to‑focus, exposure point
- External stream support (HTTP/HTTPS IP/Wi‑Fi camera URLs)
- Local gallery to review, share, and manage recordings
- Sound notifications for motion and recording status
- Screen wake management for long observation sessions
- Trial and unlock flow via in‑app purchase
How It Works

- Choose camera source: device camera or IP/Wi‑Fi stream
- Pick a color mode tailored to your scene
- Arm motion detection; the app records automatically on movement
- Recording stops after inactivity and saves clips locally
- Review clips in the in‑app gallery
Beyond the Visible

- Vision limits: approx. 400–700 nm
- Infrared and ultraviolet modes emphasize bands the eye cannot see
- Filters improve contrast and low‑light visibility to reveal subtle phenomena
Project Structure

- Main screen: ufo_capture_app/lib/screens/camera_screen.dart
- Intro video: ufo_capture_app/lib/screens/intro_video_screen.dart
- Gallery: ufo_capture_app/lib/screens/gallery_screen.dart
- Settings: ufo_capture_app/lib/screens/settings_screen.dart
- Motion detection service: ufo_capture_app/lib/services/motion_detection_service.dart
- Native color filter bridge (MethodChannel ufo_color_filters ): applied on saved videos when a non‑RGB mode is selected
Storage

- Saved clips directory: ApplicationDocumentsDirectory/UFOCaptures
- Filenames: ufo_capture_<timestamp>.mp4
Requirements

- Flutter SDK (3.9.x or compatible)
- Permissions: Camera and Microphone
- Physical device recommended for full functionality (simulators lack real cameras)
Dependencies

- camera for capture and preview
- video_player for external streams and intro video
- permission_handler for runtime permissions
- path_provider and path for file storage
- provider for state
- wakelock_plus to keep the screen awake
- flutter_local_notifications for alerts
Setup

- Pub dependencies:
```
flutter pub get
```
- iOS:
  - Ensure NSCameraUsageDescription and NSMicrophoneUsageDescription in Info.plist
  - Use a physical device for camera testing; simulators return no cameras
  - If CocoaPods issues occur:
```
cd ios && pod install && cd ..
```
- Android:
  - Confirm CAMERA and RECORD_AUDIO permissions in AndroidManifest.xml
  - Test on a physical device for camera and audio recording
Run

- Device (debug):
```
flutter run
```
- iOS specific device selection:
```
flutter devices
flutter run -d <DEVICE_ID>
```
External Streams

- Enter a valid HTTP/HTTPS URL for IP/Wi‑Fi cameras
- Stream playback uses VideoPlayerController.networkUrl(Uri.parse(url))
Color Modes

- RGB: natural color
- Black & White: contrast and luminance emphasis
- Infrared: red‑channel emphasis to surface subtle heat‑like cues
- Ultra Violet: violet emphasis to highlight fine atmospheric detail
- Night Vision: low‑light enhancement
- CMYK: color separation for atypical color signatures
- Preview applies filters live; saved videos are processed through the native filter bridge when a non‑RGB mode is selected
Notifications

- Motion detected / recording start/stop notifications for quick feedback
Known Limitations

- iOS simulators do not provide camera devices; use a physical device to test capture and recording
- External streams depend on the availability and format of the provided URL

Developer Resources

- **GitHub Copilot Free Access**: Open [copilot-free-access.html](./copilot-free-access.html) to access GitHub Copilot settings and free usage options for students and educators
