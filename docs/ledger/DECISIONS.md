# Decisions

- Android-first application.
- Flutter/Dart UI with Kotlin platform integration and Rust core, subject to supplied blueprint verification.
- No homegrown cryptographic primitives.
- Secure-by-default; no plaintext server-side message handling.
- Build and test claims must have evidence. Independent security review is required before public launch.

## P01 dependency and platform decisions

- Dynamic system colours use `dynamic_color ^2.1.0`, the Material-maintained package. It exposes light and dark schemes from Android S+ dynamic colour.
- Phosphor icons use `phosphor_icons ^3.0.1`, the FuncCloud-maintained compatibility fork.
- First-party Sargoshi logo artwork is bundled as local SVG assets and rendered with `flutter_svg ^2.5.1`; no external logo service or runtime asset download is used. The fork addresses Flutter 3.43+ `IconData` changes, retains Phosphor's family/weights, and has all supplied icon names verified in its source registries.
- Four font families are bundled from a pinned Google Fonts repository revision and remain unmodified under their SIL Open Font Licences. Fonts are not fetched at runtime.
- `shared_preferences` is reserved for low-sensitivity user preferences only (theme, language, performance choice). It is not an encrypted vault, secure key store, or message database. Secrets and message content must use the dedicated secure storage/data architecture introduced in later phases.
- If native device profiling is unavailable or returns malformed data, performance detection falls back to conservative T1 and emits only a fixed allow-listed event; it never logs raw device payload or exception text.
- The component gallery is compiled/routed only in debug mode; gallery controls are local previews and are not connected to production services.
