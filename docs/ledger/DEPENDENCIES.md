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

| Package | Pin | Reason |
|---|---:|---|
| `flutter_riverpod` | `^2.6.1` | App-level state and dependency injection; resolved successfully on owner's Flutter 3.47.7 toolchain |
| `go_router` | `^14.8.1` | Declarative route configuration; resolved and compiled on owner's toolchain |
| `dynamic_color` | `^2.1.0` | Material team package for platform wallpaper/accent-derived color schemes; supports Android S+ |
| `phosphor_icons` | `^3.0.1` | Phosphor 1,500+ icon family, six weights, compatibility fork for Flutter 3.43+ where `IconData` became final |
| `flutter_lints` | `^5.0.0` | Static analysis baseline |

The Phosphor package choice is deliberately `phosphor_icons`, not the older `phosphor_flutter` package. The compatibility fork maintains the existing Phosphor visual family and supplies the Flutter 3.43+ compatible `IconData` declarations. Every one of the 46 semantic names in the supplied `icons.csv` was verified against its published regular icon registry.

## Bundled font dependencies

Four variable-font families are bundled locally; there is no runtime font download:
- Plus Jakarta Sans — OFL 1.1.
- Inter — OFL 1.1.
- JetBrains Mono — OFL 1.1.
- Noto Naskh Arabic — OFL 1.1.

Exact upstream revision, licence-file locations and SHA-256 values are recorded in `docs/compliance/LICENSES.md`.

## Owner-run verification
- `flutter analyze`: PASS — no issues found (before P01 token/theme dependency update).
- `flutter test`: PASS — one widget test (before P01 token/theme dependency update).
- `flutter run`: PASS — debug APK built, installed and launched on Android 17/API 37 (before P01 token/theme dependency update).
- No release build, Rust build or independent security review has been run.

After each dependency change, run `flutter pub get`, commit `pubspec.lock`, then run analyze and tests. No dependency update is considered verified until those checks pass.
