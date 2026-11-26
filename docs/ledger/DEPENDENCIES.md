# Dependencies and toolchain baseline

## Owner Windows report (2026-11-26)

| Tool | Reported version / state |
|---|---|
| Flutter | 3.47.7 stable |
| Dart | 3.13.5 |
| Java | OpenJDK 25.0.4 (Android Studio JBR; PowerShell PATH was fixed for this session) |
| Android SDK | Root `C:\\Android\\Sdk`; SDK Platform 37 and Build-Tools 37 reported earlier |
| Android emulator | Android 17 / API 37, x86_64; AVDs `Pixel_8`, `Pixel_Play_API36` |
| Rust | 1.96.0 |
| Cargo | 1.96.0 |
| rustup | 1.29.0 |
| Node.js | 22.22.3 |
| npm | 10.9.8 |
| Git | 2.54.0.windows.1 |
| Docker | 29.9.2 |
| Docker Compose | 5.6.1 |
| ADB | 37.0.1 |

## Reported Rust targets

- `aarch64-linux-android`
- `x86_64-linux-android`
- `x86_64-pc-windows-msvc`

`armv7-linux-androideabi` is not present in the supplied installed-target output and remains outstanding.

## Initial Flutter app dependencies (resolved locally by owner)

- `flutter_riverpod 2.6.1`
- `go_router 14.8.1`
- `flutter_lints 5.0.0`

These are initial compatible constraints, not a completed dependency security/licence/maintenance review. Record transitive package versions from the owner's lockfile after the lockfile is committed.

## Verification evidence
- Owner reports `flutter analyze` passed with no issues.
- Owner reports `flutter test` passed (one widget test).
- Owner reports `flutter run` built and launched the debug APK on Android 17/API 37.
- `flutter doctor -v` previously timed out while checking the Android toolchain. The debug build succeeded, but the doctor timeout remains documented rather than hidden.

## Outstanding P00 verification
- Confirm installed Android SDK Platform 36.
- Confirm Android Build-Tools and an NDK version/path.
- Install and verify `armv7-linux-androideabi`.
- Run the full P00 gate from the complete restored project pack on the owner's Windows machine.

No release or security certification is implied by a successful debug build.
