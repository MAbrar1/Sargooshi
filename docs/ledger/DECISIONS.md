# Decisions

- Android-first application.
- Flutter/Dart UI with Kotlin platform integration and Rust core, subject to supplied blueprint verification.
- No homegrown cryptographic primitives.
- Secure-by-default; no plaintext server-side message handling.
- Build and test claims must have evidence. Independent security review is required before public launch.

## P01 dependency decisions

- Dynamic system colours: use `dynamic_color ^1.9.0`, published by the Material team. It exposes light/dark schemes from Android S+ wallpaper colours and supports the requested dynamic theme while preserving the product's non-dynamic presets.
- Phosphor icon package: use `phosphor_icons ^3.0.1` (FuncCloud-maintained compatibility fork) rather than the upstream `phosphor_flutter 2.1.0`. The upstream package is listed on pub.dev as last published two years ago; the fork documents Flutter 3.43+ compatibility after Flutter made `IconData` final. This avoids adopting an incompatible icon wrapper on the owner's Flutter 3.47.7 / Dart 3.13.5 toolchain. The required Phosphor family, styles and icon semantics remain unchanged. The fork and its provenance must remain documented in dependency review.
