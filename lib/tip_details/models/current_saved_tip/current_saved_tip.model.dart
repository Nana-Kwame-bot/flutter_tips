import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tips_repository/tips_repository.dart';

part 'current_saved_tip.model.freezed.dart';

@freezed
class CurrentSavedTip with _$CurrentSavedTip {
  const factory CurrentSavedTip.loading() = _Loading;
  const factory CurrentSavedTip.loaded({
    required SavedTip savedTip,
  }) = _Loaded;
  const factory CurrentSavedTip.error({
    required Object error,
    StackTrace? stackTrace,
  }) = _Error;
}
