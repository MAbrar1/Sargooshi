import 'package:flutter_test/flutter_test.dart';

import 'package:sargoshi/core/performance/performance_profile.dart';
import 'package:sargoshi/core/settings/app_settings.dart';

DeviceCapabilities capabilities({
  bool lowRam = false,
  int memoryClassMb = 256,
  int totalMemoryMb = 4096,
  bool systemAi = false,
}) {
  return DeviceCapabilities(
    lowRamDevice: lowRam,
    memoryClassMb: memoryClassMb,
    totalMemoryMb: totalMemoryMb,
    systemAiAvailable: systemAi,
    source: DeviceProfileSource.nativePlatformChannel,
  );
}

void main() {
  group('hardware tier detection', () {
    test('low RAM flag or less than 3 GB selects T1', () {
      expect(
        PerformanceProfile.detectTier(capabilities(lowRam: true)),
        PerformanceTier.t1,
      );
      expect(
        PerformanceProfile.detectTier(
          capabilities(totalMemoryMb: 3071),
        ),
        PerformanceTier.t1,
      );
    });

    test('ordinary supported devices select T2', () {
      expect(
        PerformanceProfile.detectTier(
          capabilities(totalMemoryMb: 6144, systemAi: true),
        ),
        PerformanceTier.t2,
      );
      expect(
        PerformanceProfile.detectTier(
          capabilities(totalMemoryMb: 8192, systemAi: false),
        ),
        PerformanceTier.t2,
      );
    });

    test('T3 requires at least 8 GB and system AI availability', () {
      expect(
        PerformanceProfile.detectTier(
          capabilities(totalMemoryMb: 8192, systemAi: true),
        ),
        PerformanceTier.t3,
      );
    });
  });

  group('visual and user overrides', () {
    test('Lite UI On forces T1 visual profile', () {
      final profile = PerformanceProfile.resolve(
        capabilities: capabilities(totalMemoryMb: 8192, systemAi: true),
        liteUiMode: LiteUiMode.on,
      );

      expect(profile.deviceTier, PerformanceTier.t3);
      expect(profile.visualTier, PerformanceTier.t1);
      expect(profile.enableGlass, isFalse);
      expect(profile.enableSoftShadows, isFalse);
      expect(profile.transitionDuration.inMilliseconds, 150);
    });

    test('Lite UI Off restores standard visuals on low-memory devices', () {
      final profile = PerformanceProfile.resolve(
        capabilities: capabilities(totalMemoryMb: 2048),
        liteUiMode: LiteUiMode.off,
      );

      expect(profile.deviceTier, PerformanceTier.t1);
      expect(profile.visualTier, PerformanceTier.t2);
      expect(profile.maxVideoHeight, 480);
    });

    test('manual tier choice overrides automatic hardware classification', () {
      final profile = PerformanceProfile.resolve(
        capabilities: capabilities(totalMemoryMb: 2048),
        override: PerformanceTierChoice.t3,
      );

      expect(profile.deviceTier, PerformanceTier.t1);
      expect(profile.visualTier, PerformanceTier.t3);
      expect(profile.allowBundledAiModels, isFalse);
      expect(profile.maxVideoHeight, 480);
      expect(profile.enableGlass, isTrue);
      expect(profile.enableSharedElementTransitions, isTrue);
    });

    test('T1/T2/T3 media profiles have distinct thumbnail and video caps', () {
      final t1 = PerformanceProfile.resolve(
        capabilities: capabilities(totalMemoryMb: 2048),
      );
      final t2 = PerformanceProfile.resolve(
        capabilities: capabilities(totalMemoryMb: 4096),
      );
      final t3 = PerformanceProfile.resolve(
        capabilities: capabilities(totalMemoryMb: 8192, systemAi: true),
      );

      expect(t1.thumbnailEdgePixels, 160);
      expect(t1.maxVideoHeight, 480);
      expect(t2.thumbnailEdgePixels, 256);
      expect(t2.maxVideoHeight, 720);
      expect(t3.thumbnailEdgePixels, 384);
      expect(t3.maxVideoHeight, isNull);
    });
  });

  test('performance profile exports matching runtime theme visuals', () {
    final lite = PerformanceProfile.resolve(
      capabilities: capabilities(totalMemoryMb: 8192, systemAi: true),
      liteUiMode: LiteUiMode.on,
    );
    final standard = PerformanceProfile.resolve(
      capabilities: capabilities(totalMemoryMb: 4096),
    );
    final premium = PerformanceProfile.resolve(
      capabilities: capabilities(totalMemoryMb: 8192, systemAi: true),
    );

    expect(lite.themeVisuals.enableGlass, isFalse);
    expect(lite.themeVisuals.enableSoftShadows, isFalse);
    expect(lite.themeVisuals.surfaceElevation, 0);
    expect(lite.themeVisuals.transitionDuration.inMilliseconds, 150);

    expect(standard.themeVisuals.enableGlass, isFalse);
    expect(standard.themeVisuals.enableSoftShadows, isTrue);
    expect(standard.themeVisuals.surfaceElevation, 2);

    expect(premium.themeVisuals.enableGlass, isTrue);
    expect(premium.themeVisuals.enableSharedElementTransitions, isTrue);
    expect(premium.themeVisuals.blurSigma, 12);
    expect(premium.themeVisuals.surfaceElevation, 4);
  });

  test('native profile parser rejects missing or wrongly typed values', () {
    expect(
      () => DeviceCapabilities.fromPlatformMap(const {}),
      throwsFormatException,
    );
  });

  test('a missing native implementation falls back to the conservative tier',
      () {
    final profile = PerformanceProfile.resolve(
      capabilities: DeviceCapabilities.conservativeFallback,
    );

    expect(profile.deviceTier, PerformanceTier.t1);
    expect(
      profile.capabilities.source,
      DeviceProfileSource.methodNotImplemented,
    );
  });
}
