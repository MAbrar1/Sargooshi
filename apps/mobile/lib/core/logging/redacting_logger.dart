import 'dart:developer' as developer;

enum SargoshiLogLevel { debug, info, warning, error }

enum SargoshiLogEvent {
  appStarted,
  appClosed,
  storageReady,
  storageUnavailable,
  nativeProfileUnavailable,
  preferenceChanged,
  routeChanged,
  backgroundWorkStarted,
  backgroundWorkCompleted,
  backgroundWorkFailed,
  securityBoundaryRejected,
  unhandledFailure,
}

typedef SargoshiLogSink = void Function(String message, int level);

void _developerSink(String message, int level) {
  developer.log(
    message,
    name: 'sargoshi',
    level: level,
  );
}

/// Emits only allow-listed event identifiers; never accepts user content,
/// credentials, message bodies, paths, filenames, or arbitrary metadata.
class RedactingLogger {
  RedactingLogger() : _sink = _developerSink;

  const RedactingLogger.forTesting(this._sink);

  final SargoshiLogSink _sink;

  void debug(SargoshiLogEvent event) {
    _write(SargoshiLogLevel.debug, event);
  }

  void info(SargoshiLogEvent event) {
    _write(SargoshiLogLevel.info, event);
  }

  void warning(SargoshiLogEvent event) {
    _write(SargoshiLogLevel.warning, event);
  }

  void error(SargoshiLogEvent event) {
    _write(SargoshiLogLevel.error, event);
  }

  void _write(SargoshiLogLevel level, SargoshiLogEvent event) {
    final severity = switch (level) {
      SargoshiLogLevel.debug => 500,
      SargoshiLogLevel.info => 800,
      SargoshiLogLevel.warning => 900,
      SargoshiLogLevel.error => 1000,
    };
    _sink('sargoshi.${level.name}.${event.name}', severity);
  }
}

final redactingLogger = RedactingLogger();
