# Device Runs

Owner-reported results. These are not independently run by the assistant.

| ID | device | android | command | result |
|---|---|---|---|---|
| P01-SMOKE-ANALYZE-01 | Windows host | Windows 11 26H2 | `flutter analyze` (apps/mobile) | PASS — no issues found |
| P01-SMOKE-TEST-01 | Windows host / Flutter test runner | Windows 11 26H2 | `flutter test` (apps/mobile) | PASS — one widget test passed |
| P01-SMOKE-ANDROID-01 | `sdk gphone16k x86 64`, ADB `emulator-5554` | Android 17 / API 37, x86_64 | `flutter run` (apps/mobile) | PASS — debug APK built, installed and app launched. Startup log showed 154 then 62 skipped frames; collect a profile trace before drawing performance conclusions. |

## Limitations
- No release APK/build has been verified.
- No physical-device test has been reported.
- No accessibility, RTL, 200% text, golden, low-memory tier, battery or network-resilience run has been reported.
- Initial Gradle warnings about restricted Java methods and SDK XML version compatibility did not block the debug build.
