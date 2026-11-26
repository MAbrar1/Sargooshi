# Windows Development Runbook

Owner reports required tools are installed; please validate on Windows in PowerShell:

```powershell
flutter --version
flutter doctor -v
dart --version
rustc --version
cargo --version
rustup target list --installed
java -version
adb version
docker --version
docker compose version
node --version
git --version
emulator -list-avds
adb devices
```

Confirm Android SDK Platform 36, Build-Tools and NDK are installed; Rust Android targets aarch64-linux-android, armv7-linux-androideabi and x86_64-linux-android; and either an emulator or connected device is available.

Record outputs in DEPENDENCIES.md. Do not treat tool installation as verification until checks are run.
