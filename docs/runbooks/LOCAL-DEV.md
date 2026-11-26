# Windows Development Runbook

## Toolchain checks

The owner has reported the following verified components (2026-11-26): Flutter 3.47.7, Dart 3.13.5, Java 25.0.4, Android SDK Platform 36, Build-Tools 35/36/37, NDK 28.2.13676358 and 30.0.16248370, Rust 1.96 with Android ARMv7/ARM64/x86_64 targets, Android emulator, Docker, Node 22 and Git 2.54.

The Android section of `flutter doctor -v` timed out at 4m30s. Do not claim the full doctor check passed. The owner did successfully build, install and launch the initial debug APK on Android 17/API 37.

## P01 verification

Run from repository root:

```powershell
git pull origin main
node tools/gen-tokens.mjs --check
```

Then from the Flutter app directory:

```powershell
cd apps/mobile
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
flutter run
```

After package resolution, commit `apps/mobile/pubspec.lock`. Only update P01 verification records after the commands actually pass on the owner environment.

## Android host scaffold handoff

The owner generated the Flutter Android host locally. Before the native Kotlin device-profile bridge or Android manifest hardening is committed remotely, commit the generated host to GitHub so subsequent pulls cannot collide with untracked files:

```powershell
cd D:\Projects\Sargooshi
git status --short
git add apps/mobile/android apps/mobile/.gitignore
git commit -m "chore(android): add Flutter Android platform scaffold"
git push origin main
```

Do not add `.idea` or the generated `.iml` IDE workspace files. Keep generated build outputs excluded.

The device-profile bridge contract is documented at `docs/architecture/android-device-profile-bridge.md`.
