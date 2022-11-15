import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tips_repository/tips_repository.dart';

part 'saved_tips.model.freezed.dart';

@freezed
class SavedTips with _$SavedTips {
  const factory SavedTips({
    @Default(<SavedTip>[]) List<SavedTip> savedTips,
  }) = _TipStateList;
}
