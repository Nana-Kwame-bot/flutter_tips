import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tips_repository/tips_repository.dart';

part 'tips_state.freezed.dart';

@freezed
class TipsState with _$TipsState {
  const factory TipsState.initial() = _Initial;
  const factory TipsState.loadInProgress() = _LoadInProgress;
  const factory TipsState.loadSuccess({
    required List<TipUrl> tips,
    required int currentItemCount,
  }) = _LoadSuccess;
  const factory TipsState.loadFailure({
    @Default("Something went wrong") String? errorMessage,
  }) = _LoadFailure;
}
