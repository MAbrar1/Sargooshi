# PROGRESS

CURRENT_PHASE: P00

## Session log
| Date | Phase | Completed | Remaining | Resume |
|---|---|---|---|---|
| 2026-11-26 | P00/P01 | Owner verified Android SDK Platform 36, Build-Tools, NDK and all three Rust Android targets; initial Flutter shell analyzes, one widget test passes and debug APK launches. P01 spec extracts restored; full English/Urdu copy keys seeded and CSV/ARB key-placeholder consistency checked; localization CI check added | Complete P00 archive/tooling sync and Windows gate; owner rerun of expanded P01 tests/build; native Urdu review; Android host commit/native bridge and remaining P01 visual/security/test acceptance criteria | Pull main; run P01 localization/token checks, gen-l10n, analyze/test and release build; then reconcile Android host scaffold and finish P00 gate sync |

## Owner-reported toolchain verification (2026-11-26)
- Flutter stable 3.47.7; Dart 3.13.5.
- Java OpenJDK 25.0.4 is available after setting Android Studio JBR on PATH.
- Android SDK Platform 36 is installed; Build-Tools 35.0.0, 36.0.0 and 37.0.0 are installed.
- Android NDK versions 28.2.13676358 and 30.0.16248370 are installed.
- Rust 1.96.0 / Cargo 1.96.0 with targets `aarch64-linux-android`, `armv7-linux-androideabi`, `x86_64-linux-android`; Windows MSVC target also installed.
- Android emulator AVDs `Pixel_8` and `Pixel_Play_API36` exist; Android 17/API 37 x86_64 emulator is connected at `emulator-5554`.
- Docker 29.9.2; Docker Compose 5.6.1; Node 22.22.3; Git 2.54.0; ADB 37.0.1.
- Owner's `flutter doctor -v` Android toolchain check timed out at 4m30s. It is not marked as passed; the app debug build nevertheless succeeded.

## Owner-reported application smoke test (2026-11-26)
- `flutter analyze` in `apps/mobile`: PASS — no issues found on the initial shell.
- `flutter test` in `apps/mobile`: PASS — the initial widget test passed.
- `flutter run` in `apps/mobile`: PASS — debug APK built, installed and launched on Android 17/API 37 emulator.
- Startup log reported 154 then 62 skipped frames. This is a cold-start observation only; profile trace required before diagnosing a performance issue.
- Gradle emitted restricted-Java-method and Android SDK XML compatibility warnings; neither blocked the debug build.

## P01 implementation in progress (new work not yet owner-verified)
- Canonical design tokens live in `docs/blueprint/design-tokens.json`; `tools/gen-tokens.mjs` generates Dart theme tokens and supports stale-output `--check`.
- Theme presets include dark default, light/parchment, AMOLED, Midnight Sky, high contrast, system and Android dynamic colour.
- Four local variable-font families (Plus Jakarta Sans, Inter, JetBrains Mono, Noto Naskh Arabic) are committed with separate SIL OFL texts. Upstream commit and SHA-256 values are recorded in `docs/compliance/LICENSES.md`.
- Phosphor icon layer now contains 51 semantic entries:
- Brand marks are committed as local gradient, light and dark SVG assets. `SgLogo` provides mark-only, horizontal and stacked lockups with adaptive/light/dark treatments and semantic labels; welcome uses the brand mark. Brand dimensions are tokenized in `design-tokens.json` and generated Dart tokens. Widget tests cover all lockup variants and both brightnesses. The outlined wordmark is currently composed from bundled typography rather than the blueprint's full outlined horizontal/stacked lockup SVGs; exact lockup asset integration remains a visual-fidelity follow-up. Adaptive launcher layers, notification glyph, Android 12 splash and device-specific startup integration remain outstanding; a reusable three-arc staggered pulse widget now exists and is integrated on welcome, but still requires owner test execution and visual review.
- English/Urdu ARB resources, generated localization delegates, persisted language selection, first-strong direction/bidi-isolation helpers, Urdu search normalization and optional Eastern Arabic digit conversion are implemented. The 52-row blueprint copy catalogue is seeded in both locales; a repository check enforces source keys and interpolation placeholders. The Urdu copy is machine-drafted and remains an unreviewed draft. The copy CSV was repaired after detecting malformed quotation in the first GitHub import; the corrected file parses as 52 unique data rows.
- Shared component catalogue implements the 32 canonical catalogue rows, including the combined checkbox/radio row. It includes button variants, fields, chips, toggles, avatars, badges, list/card/bubble primitives, composer, navigation, sheets/dialogs/snackbars, banners/alerts, PIN pad, progress/stat/skeleton/empty states.
- Debug component gallery is registered behind `kDebugMode` and can be opened from the welcome screen only in debug builds. It has interactive preview controls for persisted appearance, app language, Lite UI and T1/T2/T3 visual selection.
- Adaptive size classes use 600/840 dp breakpoints and the specified 4/8/12-column spacing grid. Two-pane and conditional three-pane layouts protect the minimum chat width. A foldable posture detector now consumes Flutter display features: vertical fold/hinge maps to book layout (RTL mirrored), half-open horizontal hinge maps to tabletop video/controls, and cutouts are ignored. Synthetic widget tests cover both orientations and RTL; real foldable hardware verification remains outstanding.
- Theme preset, Lite UI, language, and user performance-tier preferences are persisted as non-secret app settings. The runtime performance profile now attaches a Material theme extension: T1 disables card shadows/blur, T2 uses standard surface elevation, and T3 enables token-defined glass blur and higher elevation. Device tier model and conservative fallback are implemented in Dart; the Android Kotlin channel implementation is still pending.
- Typed `AppError` / sealed `Result<T>` and an allow-listed redacting logger are present.
- Initial tests cover theme presets, 51 icon mappings/RTL mirroring, welcome EN/UR, shared component layout at 200% text in LTR/RTL, adaptive breakpoints/panes, bidi helpers, settings persistence, T1/T2/T3 mapping, typed results and logger allow-list. The component suite now carries SG:CMP-01 through SG:CMP-32 case identifiers, runs each catalogue row in LTR/RTL at 200% text, and adds behavioral checks for destructive-dialog cancel, snackbar undo, scrambled PIN selection, disabled/loading buttons, 78% whisper treatment and six-line attach/voice/send composer. One contradictory T1 media-cap assertion was removed. These expanded tests are committed but have not yet been rerun by the owner.
- Native Urdu review remains OPEN in `docs/ledger/EXTERNAL.md`.

## P01 remaining
- Run `node tools/gen-tokens.mjs --check`, `node tools/check-copy-catalog.mjs`, `flutter gen-l10n`, analyzer and the complete expanded test suite (including the new logo and foldable tests) on the owner machine; commit the resulting `pubspec.lock`. The Flutter quality workflow runs the token, localization, format, analyze and test checks for push and pull-request changes; no CI run has yet been verified.
- Complete component variant/state coverage beyond current catalogue render and focused behavior tests; produce visual golden tests at 360/412/600/840/1280 dp in LTR/RTL; complete accessibility audits, full 200% text overflow verification for every component, and performance profiling. Run synthetic foldable tests and later a physical foldable book/tabletop device run.
- Commit the owner's generated Android platform scaffold, then implement the native Kotlin device-profile channel, edge-to-edge/predictive-back configuration, manifest restrictions, launcher/adaptive icons, splash and platform performance behavior.
- Review generated font asset names/weights, theme contrast, logo asset visual fidelity, and component visual states on device. A staggered arc pulse is implemented as a non-blocking widget and added to welcome; focused animation/static-mode widget tests are committed but not owner-run.
- Review generated font asset names/weights, theme contrast, and component visual states on device.
- P01 is not complete until all prompt acceptance criteria and phase gates pass.

## P00 remains open
The authoritative restored project pack is present in the assistant working copy and its source integrity was checked (blueprint v5: 3,250 lines, SHA-256 `0a8769238c4f43b2a16aa8a907db5b9aa0e6964a97f7a1fb7ff7f39cb4607312`; registry: 350 data rows; ledger: 883 rows). The local archive gate and reality-scanner negative-control test passed there. However, the complete P00 tooling bundle (ledger, tree/reality/registry checkers and full gate) and all source-pack extracts are not yet synchronized into the owner's clone/GitHub main, and the full P00 gate has not been run on the owner's Windows machine. Do not change CURRENT_PHASE until that synchronization and gate evidence exist.

## Reality boundary
Only the initial minimal Flutter shell has owner-reported analyzer, test and debug-emulator evidence. All expanded P01 code is committed but unverified on the owner machine. No release build, Rust compilation, cryptographic implementation, security audit or full P01 completion is claimed.
