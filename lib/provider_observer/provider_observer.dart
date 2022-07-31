import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/main.dart';

class Logger implements ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<void> provider,
    Object? value,
    ProviderContainer container,
  ) {
    logger.v("Provider: ${provider.name ?? provider.runtimeType} initialized");
  }

  @override
  void didDisposeProvider(
    ProviderBase<void> provider,
    ProviderContainer containers,
  ) {
    logger.v("Provider: ${provider.name ?? provider.runtimeType} disposed");
  }

  @override
  void didUpdateProvider(
    ProviderBase<void> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    logger.v(
      "Provider: ${provider.name ?? provider.runtimeType}\n"
      "Previous state: ${previousValue.runtimeType} \nCurrent state: ${newValue.runtimeType}",
    );
  }

  @override
  void providerDidFail(
    ProviderBase<void> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    logger.e(
      "Provider: ${provider.name ?? provider.runtimeType} Error: \n"
      "$error Stacktrace: $stackTrace",
    );
  }
}
