import 'package:freezed_annotation/freezed_annotation.dart';

part 'tip_url.model.freezed.dart';

@freezed
class TipUrl with _$TipUrl {
  const factory TipUrl({
    required String imageUrl,
    required String codeUrl,
  }) = _TipUrl;
}
