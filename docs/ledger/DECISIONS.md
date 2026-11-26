# Decisions

- Android-first application.
- Flutter/Dart UI with Kotlin platform integration and Rust core, subject to supplied blueprint verification.
- No homegrown cryptographic primitives.
- Secure-by-default; no plaintext server-side message handling.
- Build and test claims must have evidence. Independent security review is required before public launch.

## P01 dependency decisions

- Dynamic system colours use `dynamic_color ^2.1.0`, the Material-maintained package. It exposes light and dark schemes from the platform's dynamic colour implementation, including Android S+ wallpaper palettes.
- Phosphor icons use `phosphor_icons ^3.0.1`, the FuncCloud-maintained compatibility fork of the Phosphor Flutter package. The fork documents Flutter 3.43+ compatibility after Flutter made `IconData` final. It retains the Phosphor icon family and six weights. The old `phosphor_flutter 2.1.0` is not selected because its subclassed icon-data representation conflicts with the current Flutter SDK.
- The four required fonts are bundled from a pinned Google Fonts repository revision and remain unmodified under their SIL Open Font Licences. No font is loaded from a network request at runtime.
