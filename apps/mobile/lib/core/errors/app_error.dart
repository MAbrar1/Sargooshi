enum AppErrorCode {
  invalidInput,
  unauthenticated,
  forbidden,
  unavailable,
  networkUnavailable,
  storageUnavailable,
  cryptoFailure,
  cancelled,
  unexpected,
}

class AppError {
  const AppError(this.code);

  final AppErrorCode code;

  String get localizationKey => switch (code) {
        AppErrorCode.invalidInput => 'errorInvalidInput',
        AppErrorCode.unauthenticated => 'errorUnauthenticated',
        AppErrorCode.forbidden => 'errorForbidden',
        AppErrorCode.unavailable => 'errorUnavailable',
        AppErrorCode.networkUnavailable => 'errorNetworkUnavailable',
        AppErrorCode.storageUnavailable => 'errorStorageUnavailable',
        AppErrorCode.cryptoFailure => 'errorCryptoFailure',
        AppErrorCode.cancelled => 'errorCancelled',
        AppErrorCode.unexpected => 'errorUnexpected',
      };

  factory AppError.unexpected() => const AppError(AppErrorCode.unexpected);

  @override
  String toString() => 'AppError(' + code.name + ')';
}
