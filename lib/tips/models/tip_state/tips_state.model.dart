import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tips_repository/tips_repository.dart';

part 'tips_state.model.freezed.dart';

@freezed
class TipsState with _$TipsState {
  const factory TipsState.initial() = _Initial;
  const factory TipsState.loading() = _Loading;
  const factory TipsState.loaded({
    required List<Tip> tips,
    required int currentItemCount,
  }) = _Loaded;
  const factory TipsState.error({
    required Object error,
    StackTrace? stackTrace,
  }) = _Error;
}
