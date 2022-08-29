import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_tip.model.freezed.dart';
part 'saved_tip.model.g.dart';

@freezed
class SavedTip with _$SavedTip {
  const factory SavedTip({
    required String imagePath,
    required String codePath,
    required String title,
  }) = _SavedTip;

  factory SavedTip.fromJson(Map<String, dynamic> json) =>
      _$SavedTipFromJson(json);
}
