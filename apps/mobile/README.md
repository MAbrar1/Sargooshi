# Sargoshi Flutter client

Android-first Flutter client for Sargoshi — Say it softly.

## Local setup

Generate the Android host scaffold once (the generated Android directory is kept in source control):

```powershell
cd apps/mobile
flutter create --org app.sargoshi --project-name sargoshi --platforms android .
```

Restore packages and generate localization code:

```powershell
flutter pub get
flutter gen-l10n
```

## P01 verification

Run from the repository root:

```powershell
node tools/gen-tokens.mjs --check
```

Then run from `apps/mobile`:

```powershell
flutter analyze
flutter test
flutter run
```

Commit `pubspec.lock` after dependency resolution. Record owner-run analyzer, test, and device evidence in `docs/quality/DEVICE-RUNS.md`.

## Debug gallery

In debug builds only, tap the bug icon on the welcome screen or navigate to `/debug/gallery`. The gallery previews shared components and local preference controls. It is excluded from release routing and does not connect to production services.

## Reality boundary

The welcome surface and design-system shell are implemented. The gallery is a component preview, not a messaging experience. Account, cryptographic identity, encrypted storage, secure messaging, calls, Vault, backup and server integrations are not yet implemented. Do not represent them as functional.
