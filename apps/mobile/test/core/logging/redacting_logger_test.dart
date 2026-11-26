import 'package:flutter_test/flutter_test.dart';

import 'package:sargoshi/core/logging/redacting_logger.dart';

void main() {
  test('logger emits only allow-listed event identifiers and severity', () {
    final events = <(String, int)>[];
    final logger = RedactingLogger.forTesting(
      (message, level) => events.add((message, level)),
    );

    logger.info(SargoshiLogEvent.storageReady);
    logger.warning(SargoshiLogEvent.nativeProfileUnavailable);
    logger.error(SargoshiLogEvent.unhandledFailure);

    expect(events, [
      ('sargoshi.info.storageReady', 800),
      ('sargoshi.warning.nativeProfileUnavailable', 900),
      ('sargoshi.error.unhandledFailure', 1000),
    ]);
  });

  test('public logging API cannot accept arbitrary message content', () {
    final events = <String>[];
    final logger = RedactingLogger.forTesting(
      (message, _) => events.add(message),
    );

    logger.error(SargoshiLogEvent.securityBoundaryRejected);

    expect(events.single, 'sargoshi.error.securityBoundaryRejected');
    expect(events.single, isNot(contains('private message')));
    expect(events.single, isNot(contains('secret token')));
  });
}
