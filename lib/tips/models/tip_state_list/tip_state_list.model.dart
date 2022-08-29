import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tips_repository/tips_repository.dart';

part 'tip_state_list.model.freezed.dart';
part 'tip_state_list.model.g.dart';

@freezed
class TipStateList with _$TipStateList {
  const factory TipStateList({
    @Default(<SavedTip>[]) List<SavedTip> savedTips,
  }) = _TipStateList;

  factory TipStateList.fromJson(Map<String, dynamic> json) =>
      _$TipStateListFromJson(json);
}
