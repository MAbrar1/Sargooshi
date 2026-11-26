# Dependencies and toolchain baseline

## Owner Windows toolchain report (2026-11-26)

| Tool | Reported version / state |
|---|---|
| Flutter | 3.47.7 stable |
| Dart | 3.13.5 |
| Java | OpenJDK 25.0.4 (Android Studio JBR; PATH fixed for the PowerShell session) |
| Android SDK | Root `C:\Android\Sdk`; Platform 36 confirmed |
| Android Build-Tools | 35.0.0, 36.0.0, 37.0.0 |
| Android NDK | 28.2.13676358 and 30.0.16248370 |
| Emulator | AVDs `Pixel_8`, `Pixel_Play_API36`; Android 17/API 37 x86_64 connected |
| Rust / Cargo | 1.96.0 |
| Rust targets | `aarch64-linux-android`, `armv7-linux-androideabi`, `x86_64-linux-android`, `x86_64-pc-windows-msvc` |
| Node.js | 22.22.3 |
| npm | 10.9.8 |
| Git | 2.54.0.windows.1 |
| Docker | 29.9.2 |
| Docker Compose | 5.6.1 |
| ADB | 37.0.1 |

`flutter doctor -v` timed out after 4m30s in its Android toolchain check. Do not record doctor as clean. The owner did build, install and launch the debug APK successfully.

## Flutter application dependencies

Initial locally resolved dependencies:
- `flutter_riverpod 2.6.1`
- `go_router 14.8.1`
- `flutter_lints 5.0.0`

P01 additions selected after checking current package metadata:
- `dynamic_color ^1.9.0` — Material-published dynamic wallpaper/accent colour integration; Apache-2.0. It supports Android S+ wallpaper-derived schemes.
- `phosphor_icons ^3.0.1` — maintained compatibility fork of the Phosphor Flutter library for Flutter 3.43+ / Dart 3.x final `IconData`. This is used instead of the old upstream `phosphor_flutter 2.1.0`, which pub.dev lists as published two years ago. The fork is MIT-licensed. See DECISIONS.md for the compatibility rationale.

Run `flutter pub get` after pulling the dependency change and commit the resulting `pubspec.lock`. Transitive package versions and hashes should be recorded from that lockfile.

## Owner-run verification
- `flutter analyze`: PASS — no issues found.
- `flutter test`: PASS — one widget test passed.
- `flutter run`: PASS — debug APK built, installed and launched on Android 17/API 37.
- No release build, Rust build or independent security review has been run.

## P00 close-out blocker
The restored source archive's full ledger, spec-data, prompt pack and Node gate tools must be synchronized into the owner clone and the Windows P00 full gate executed. P00 remains open until then.
