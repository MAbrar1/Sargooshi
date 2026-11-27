# PROGRESS

CURRENT_PHASE: P00

## Verified checkpoint — 2026-11-27

- GitHub `main` contains commit `5093bb9363bd406b230cbd59802fb0798ad89887` (`style(mobile): format Dart sources and tests`).
- Owner-reported Windows verification after pulling the gallery layout fix: `flutter gen-l10n` passed; `dart format` checked 38 Dart files with 0 changes; `flutter analyze` reported no issues; `flutter test --reporter expanded --concurrency=1` passed all 127 tests.
- GitHub Actions run #118 for commit `5093bb9` passed every step: generated-token check, localization catalogue, dependency resolution, localization generation, formatter, analyzer and tests.
- No current-code `flutter run`, release APK, Rust build or P01 full gate has been verified after this checkpoint.
- The owner-generated Android host scaffold and `pubspec.lock` were still untracked locally in the last supplied `git status`; neither is present on GitHub `main`. The IDE `.iml` file must stay out of version control.
- Current repository is intentionally still marked P00. Do not advance the phase based only on clean Flutter tests and CI.

## Session log

| Date | Phase | Completed | Remaining / resume |
|---|---|---|---|
| 2026-11-27 | P01 verification | Fixed the debug gallery's NavigationRail preview by constraining it to a finite height. Owner then passed localization generation, formatting (38 files, 0 changes), analysis and 127 tests. Commit `5093bb9`; GitHub Actions #118 passed. | Sync the canonical P00 source pack and gate tools into the repository; commit the Android host scaffold and lockfile; continue P01 acceptance work. |
| 2026-11-27 | P01 repair series | Resolved Phosphor icon const errors, dynamic_color ColorScheme incompatibility, localization getter errors, invalid adaptive test const expressions, lints and component/gallery layout regressions. Added regression coverage for RTL, 200% text, settings persistence, gallery navigation and trailing count badge layout. | P01 remains open until every requirement, evidence item and phase gate is complete. |
| 2026-11-26 | P00/P01 bootstrap | Owner verified Android SDK Platform 36, Build-Tools, NDK, Rust Android targets and initial debug APK launch on Android 17/API 37. | Complete P00 source-pack/tooling synchronization and owner Windows gate; finish P01 implementation and acceptance. |

## Owner-reported toolchain baseline

- Flutter stable 3.47.7; Dart 3.13.5.
- Java OpenJDK 25.0.4 through Android Studio JBR.
- Android SDK root `C:\\Android\\Sdk`; Platform 36; Build-Tools 35/36/37; NDK 28.2.13676358 and 30.0.16248370.
- Rust/Cargo 1.96.0 with `aarch64-linux-android`, `armv7-linux-androideabi`, `x86_64-linux-android` and Windows MSVC target.
- Node 22.22.3, Git 2.54.0, Docker 29.9.2, Docker Compose 5.6.1, ADB 37.0.1.
- `flutter doctor -v` timed out during its Android toolchain check; it is not recorded as a clean pass.

## P01 implementation state

Implemented and now owner/CI verified at the Flutter source/test level:

- Generated design-token pipeline and theme presets (dark default, light/parchment, AMOLED, Midnight Sky, high contrast, system and dynamic colour).
- Bundled Plus Jakarta Sans, Inter, JetBrains Mono and Noto Naskh Arabic fonts with OFL licence files.
- Semantic Phosphor icon layer, Sargoshi mark SVGs and mark/horizontal/stacked logo widget scaffolding.
- English/Urdu ARB resources, persisted language preference, bidi isolation, Urdu search normalization and optional Eastern Arabic digits.
- 32 shared component catalogue entries, debug-only component gallery, interactive local preference previews.
- Adaptive size classes, scaffold/rail and pane layouts, synthetic foldable book/tabletop behavior, theme/performance preferences, typed errors and allow-listed redacting logger.
- Owner-run test suite currently passes 127 tests, including component LTR/RTL layouts at 200% text scale.

Still required before P01 can close:

1. Synchronize the canonical source pack into this repository: full v5 blueprint, all phase prompts, full spec-data, `status.csv`, ledger/tree/reality/registry/gate tools and their CI. The restored archive has been integrity-checked separately, but those files are not yet on GitHub `main`.
2. Commit the owner's generated `apps/mobile/android` scaffold and `apps/mobile/pubspec.lock` (exclude IDE `.iml` files). Then implement the Kotlin `app.sargoshi/device_profile` / `getDeviceProfile` bridge according to `docs/architecture/android-device-profile-bridge.md`.
3. Complete Android manifest/privacy configuration, adaptive launcher layers, notification glyph, Android 12 splash and startup integration.
4. Complete all 11 reusable chat-anatomy regions and remaining scaffold anatomy widgets without creating real messaging screens prematurely.
5. Complete per-component state/interaction coverage and the golden matrix at 360/412/600/840/1280 dp in both LTR and RTL; export goldens for owner visual review.
6. Perform contrast/accessibility review, visual review on the current emulator build, 200% text and RTL checks, performance profiling and a release APK build.
7. Obtain native Urdu review for `app_ur.arb`; this remains OPEN in `docs/ledger/EXTERNAL.md`.

The restored source ledger snapshot lists 36 P01 rows (2 Registry, 2 Settings, 32 Components) as NOT_STARTED. Since that ledger has not yet been synchronized/reconciled with the implemented work and evidence, no row is claimed closed here. Do not hand-edit `status.csv`; use the ledger tool after its synchronization.

## P00 remains open

The restored archive `sargoshi_p00_restored.zip` was checked in the working copy:
- Blueprint v5: 3,250 lines; SHA-256 `0a8769238c4f43b2a16aa8a907db5b9aa0e6964a97f7a1fb7ff7f39cb4607312`.
- Registry: 350 data rows.
- Status ledger: 883 rows.
- `node tools/gate.mjs --phase P00 --full`: PASS in the restored working copy (tree, reality and registry checks).

This is not a pass in the owner's clone or on GitHub `main`. The complete P00 tooling/source pack is not yet synchronized into the repository, and the owner has not run the full P00 gate in their Windows clone. Keep `CURRENT_PHASE: P00` until synchronization and owner evidence exist.

## P02 boundary

Do not start Rust cryptographic implementation yet. P01 still has explicit acceptance work, and P00's canonical source/tooling pack is not synchronized. When P02 begins, use the restored P02 prompt and blueprint crypto specification; never invent primitives or write bespoke cryptography.

## Reality boundary

The Flutter foundation is no longer in the earlier failing state: owner-reported analysis and all 127 tests pass, and GitHub Actions #118 is green. This verifies the current Dart quality pipeline only. It does not establish P00/P01 phase completion, Android native bridge behavior, release build success, a security audit, Rust compilation, or production messaging functionality.
