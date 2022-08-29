import 'package:freezed_annotation/freezed_annotation.dart';

part 'tip.model.freezed.dart';
part 'tip.model.g.dart';

@freezed
class Tip with _$Tip {
  const factory Tip({
    required String imageUrl,
    required String codeUrl,
    required String title,
  }) = _Tip;

  factory Tip.fromJson(Map<String, dynamic> json) => _$TipFromJson(json);
}
