import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logging/redacting_logger.dart';
import '../settings/app_settings.dart';
import '../theme/generated/sargoshi_tokens.g.dart';
import '../theme/performance_visuals.dart';

enum PerformanceTier { t1, t2, t3 }

enum DeviceProfileSource {
  nativePlatformChannel,
  methodNotImplemented,
  platformFailure,
  invalidNativePayload,
}

class DeviceCapabilities {
  const DeviceCapabilities({
    required this.lowRamDevice,
    required this.memoryClassMb,
    required this.totalMemoryMb,
    required this.systemAiAvailable,
    required this.source,
  });

  final bool lowRamDevice;
  final int memoryClassMb;
  final int totalMemoryMb;
  final bool systemAiAvailable;
  final DeviceProfileSource source;

  static const conservativeFallback = DeviceCapabilities(
    lowRamDevice: true,
    memoryClassMb: 0,
    totalMemoryMb: 0,
    systemAiAvailable: false,
    source: DeviceProfileSource.methodNotImplemented,
  );

  factory DeviceCapabilities.fromPlatformMap(Map<String, Object?> values) {
    final lowRam = values['lowRamDevice'];
    final memoryClass = values['memoryClassMb'];
    final totalMemory = values['totalMemoryMb'];
    final systemAi = values['systemAiAvailable'];

    if (lowRam is! bool ||
        memoryClass is! int ||
        totalMemory is! int ||
        systemAi is! bool ||
        memoryClass < 0 ||
        totalMemory <= 0) {
      throw const FormatException('Invalid device profile payload');
    }

    return DeviceCapabilities(
      lowRamDevice: lowRam,
      memoryClassMb: memoryClass,
      totalMemoryMb: totalMemory,
      systemAiAvailable: systemAi,
      source: DeviceProfileSource.nativePlatformChannel,
    );
  }
}

abstract final class DeviceProfileChannel {
  static const MethodChannel _channel =
      MethodChannel('app.sargoshi/device_profile');

  static Future<DeviceCapabilities> read() async {
    try {
      final values = await _channel.invokeMapMethod<String, Object?>(
        'getDeviceProfile',
      );
      if (values == null) {
        return const DeviceCapabilities(
          lowRamDevice: true,
          memoryClassMb: 0,
          totalMemoryMb: 0,
          systemAiAvailable: false,
          source: DeviceProfileSource.invalidNativePayload,
        );
      }
      return DeviceCapabilities.fromPlatformMap(values);
    } on MissingPluginException {
      redactingLogger.warning(SargoshiLogEvent.nativeProfileUnavailable);
      return DeviceCapabilities.conservativeFallback;
    } on PlatformException {
      redactingLogger.warning(SargoshiLogEvent.nativeProfileUnavailable);
      return const DeviceCapabilities(
        lowRamDevice: true,
        memoryClassMb: 0,
        totalMemoryMb: 0,
        systemAiAvailable: false,
        source: DeviceProfileSource.platformFailure,
      );
    } on FormatException {
      redactingLogger.warning(SargoshiLogEvent.nativeProfileUnavailable);
      return const DeviceCapabilities(
        lowRamDevice: true,
        memoryClassMb: 0,
        totalMemoryMb: 0,
        systemAiAvailable: false,
        source: DeviceProfileSource.invalidNativePayload,
      );
    }
  }
}

class PerformanceProfile {
  const PerformanceProfile({
    required this.deviceTier,
    required this.visualTier,
    required this.capabilities,
    required this.isUserOverridden,
  });

  final PerformanceTier deviceTier;
  final PerformanceTier visualTier;
  final DeviceCapabilities capabilities;
  final bool isUserOverridden;

  bool get enableGlass => visualTier == PerformanceTier.t3;
  bool get enableSharedElementTransitions => visualTier == PerformanceTier.t3;
  bool get enableSoftShadows => visualTier != PerformanceTier.t1;
  bool get allowBundledAiModels => deviceTier != PerformanceTier.t1;
  bool get systemAiAvailable => capabilities.systemAiAvailable;

  int get thumbnailEdgePixels => switch (deviceTier) {
        PerformanceTier.t1 => 160,
        PerformanceTier.t2 => 256,
        PerformanceTier.t3 => 384,
      };

  int? get maxVideoHeight => switch (deviceTier) {
        PerformanceTier.t1 => 480,
        PerformanceTier.t2 => 720,
        PerformanceTier.t3 => null,
      };

  Duration get transitionDuration => switch (visualTier) {
        PerformanceTier.t1 => SargoshiMotion.tier1Screen,
        PerformanceTier.t2 => SargoshiMotion.standard,
        PerformanceTier.t3 => SargoshiMotion.screen,
      };

  SargoshiPerformanceVisuals get themeVisuals => SargoshiPerformanceVisuals(
        transitionDuration: transitionDuration,
        enableGlass: enableGlass,
        enableSharedElementTransitions: enableSharedElementTransitions,
        enableSoftShadows: enableSoftShadows,
        blurSigma: enableGlass ? SargoshiEffects.glassBlurSigma : 0,
        surfaceElevation: switch (visualTier) {
          PerformanceTier.t1 => 0,
          PerformanceTier.t2 => SargoshiElevation.card,
          PerformanceTier.t3 => SargoshiElevation.glass,
        },
      );

  static PerformanceProfile resolve({
    required DeviceCapabilities capabilities,
    LiteUiMode liteUiMode = LiteUiMode.auto,
    PerformanceTierChoice override = PerformanceTierChoice.auto,
  }) {
    final detected = detectTier(capabilities);
    final deviceTier = switch (override) {
      PerformanceTierChoice.auto => detected,
      PerformanceTierChoice.t1 => PerformanceTier.t1,
      PerformanceTierChoice.t2 => PerformanceTier.t2,
      PerformanceTierChoice.t3 => PerformanceTier.t3,
    };

    final visualTier = switch (liteUiMode) {
      LiteUiMode.on => PerformanceTier.t1,
      LiteUiMode.off => deviceTier == PerformanceTier.t1 &&
              override == PerformanceTierChoice.auto
          ? PerformanceTier.t2
          : deviceTier,
      LiteUiMode.auto => deviceTier,
    };

    return PerformanceProfile(
      deviceTier: deviceTier,
      visualTier: visualTier,
      capabilities: capabilities,
      isUserOverridden: override != PerformanceTierChoice.auto ||
          liteUiMode != LiteUiMode.auto,
    );
  }

  static PerformanceTier detectTier(DeviceCapabilities capabilities) {
    if (capabilities.lowRamDevice || capabilities.totalMemoryMb < 3072) {
      return PerformanceTier.t1;
    }
    if (capabilities.totalMemoryMb >= 8192 &&
        capabilities.systemAiAvailable) {
      return PerformanceTier.t3;
    }
    return PerformanceTier.t2;
  }
}

final deviceCapabilitiesProvider = FutureProvider<DeviceCapabilities>(
  (ref) => DeviceProfileChannel.read(),
);

final performanceProfileProvider = Provider<PerformanceProfile>((ref) {
  final capabilities = ref.watch(deviceCapabilitiesProvider).valueOrNull ??
      DeviceCapabilities.conservativeFallback;
  final liteUiMode =
      ref.watch(liteUiModeProvider).valueOrNull ?? LiteUiMode.auto;
  final override =
      ref.watch(performanceTierChoiceProvider).valueOrNull ??
          PerformanceTierChoice.auto;

  return PerformanceProfile.resolve(
    capabilities: capabilities,
    liteUiMode: liteUiMode,
    override: override,
  );
});
