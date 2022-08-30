import 'package:freezed_annotation/freezed_annotation.dart';

part 'code_string.model.freezed.dart';

@freezed
class CodeString with _$CodeString {
  const factory CodeString.loading() = _Loading;
  const factory CodeString.loaded({
    required String codeString,
  }) = _Loaded;
  const factory CodeString.error({
    required Object error,
    StackTrace? stackTrace,
  }) = _Error;
}
