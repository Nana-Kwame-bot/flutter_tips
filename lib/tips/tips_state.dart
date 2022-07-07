part of 'tips_bloc.dart';

@freezed
class TipsState with _$TipsState {
  const factory TipsState.initial() = _Initial;
  const factory TipsState.loadInProgress() = _LoadInProgress;
  const factory TipsState.loadSuccess({
    required List<TipUrl> tips,
    required int currentItemCount,
  }) = _LoadSuccess;
  const factory TipsState.loadFailure([
    @Default("Something went wrong") String? errorMessage,
  ]) = _LoadFailure;
}
