import 'package:flutter_test/flutter_test.dart';

import 'package:sargoshi/core/errors/app_error.dart';
import 'package:sargoshi/core/errors/result.dart';

void main() {
  test('success returns the typed value through fold', () {
    const result = Success<int>(42);

    expect(result.isSuccess, isTrue);
    expect(result.isFailure, isFalse);
    expect(
      result.fold(
        onSuccess: (value) => 'value:$value',
        onFailure: (error) => 'error:${error.code.name}',
      ),
      'value:42',
    );
  });

  test('failure exposes a safe typed code, not the original exception', () {
    const result = Failure<String>(
      AppError(AppErrorCode.storageUnavailable),
    );

    expect(result.isFailure, isTrue);
    expect(
      result.fold(
        onSuccess: (value) => value,
        onFailure: (error) => error.localizationKey,
      ),
      'errorStorageUnavailable',
    );
    expect(result.toString(), isNot(contains('password')));
  });

  test('unexpected errors do not preserve arbitrary exception messages', () {
    final error = AppError.unexpected();

    expect(error.code, AppErrorCode.unexpected);
    expect(error.toString(), 'AppError(unexpected)');
    expect(error.localizationKey, 'errorUnexpected');
  });
}
