# Android device-profile bridge contract

P01 requires the native Android host to report device capabilities so Dart can select T1/T2/T3 without guessing from model names.

## Channel

- Channel: `app.sargoshi/device_profile`
- Method: `getDeviceProfile`
- Invocation: `MethodChannel.invokeMapMethod<String, Object?>`
- Response: a non-null map with the fields below.

| Key | Kotlin type | Meaning |
|---|---|---|
| `lowRamDevice` | Boolean | `ActivityManager.isLowRamDevice` |
| `memoryClassMb` | Int | `ActivityManager.memoryClass` |
| `totalMemoryMb` | Int | `ActivityManager.MemoryInfo.totalMem / (1024 * 1024)` |
| `systemAiAvailable` | Boolean | Whether the supported Android system-AI service is installed and available |

The response must not contain device serial numbers, hardware identifiers, package inventory, account details, or user content.

## Dart behavior

- A valid response is marked `nativePlatformChannel`.
- A missing plugin, `PlatformException`, or malformed payload produces a conservative T1 capability profile and a single allow-listed `nativeProfileUnavailable` log event.
- No platform exception text or raw device details are logged.
- Automatic tier mapping:
  - T1 if the device declares low-RAM or reports less than 3 GB total memory.
  - T3 only with at least 8 GB total memory and system-AI availability.
  - T2 otherwise.
- User performance selection and Lite UI mode are applied after hardware classification.

## Android owner integration constraint

The Flutter-generated `apps/mobile/android` project currently exists in the owner's local clone but has not yet been committed to this repository. Add the channel handler in the generated `MainActivity.kt` and register the exact channel above after the owner commits the generated platform scaffold. Do not create parallel Android host files or overwrite the generated project.
