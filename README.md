# Mega Tic-Tac-Toe

Classic-style Ultimate Tic-Tac-Toe experience with:
- Adaptive AI (`Easy`, `Medium`, `Hard`)
- Persistent app settings (difficulty/sound/vibration/animations)
- Legal pages (Privacy Policy + Terms & Conditions)
- Release-ready mobile branding (launcher icon + splash config)

## Run

```bash
flutter pub get
flutter run
```

## AI Balance Simulation

Run the simulation script to compare AI tiers and average decision time.

```bash
dart run tool/ai_balance_simulation.dart --games 60 --seed 2026
```

Useful arguments:
- `--games`: games per matchup
- `--seed`: random seed for reproducibility

Current tuning target:
- `Easy`: mostly random, very fast
- `Medium`: tactical search with light randomness
- `Hard`: deeper search with strict time budgets to stay responsive

## Settings

In-app `Settings` screen supports persistent:
- Default AI difficulty
- Sound effects on move
- Vibration feedback on move
- Animations on/off

Storage backend: `shared_preferences`.

## Release Readiness

### Package IDs
- Android applicationId/namespace: `com.megatictactoe.game`
- iOS/macOS bundle ID: `com.megatictactoe.game`

### Versioning
- App version is managed in `pubspec.yaml`:
  - `version: 1.1.0+2`

### Launcher Icons

Configured with `flutter_launcher_icons` using:
- `assets/branding/app_icon.png`

Regenerate:
```bash
dart run flutter_launcher_icons
```

### Native Splash

Configured with `flutter_native_splash`:
- Dark classic background + centered logo

Regenerate:
```bash
dart run flutter_native_splash:create
```

### Android Signing

1. Copy `android/key.properties.example` to `android/key.properties`
2. Fill actual keystore values
3. Build release:

```bash
flutter build apk --release
```

If `android/key.properties` is missing, release build falls back to debug signing for local testing.
