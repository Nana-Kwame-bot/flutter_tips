import 'package:freezed_annotation/freezed_annotation.dart';
part 'tip_option.model.freezed.dart';

@freezed
class TipOption with _$TipOption {
  const factory TipOption({
    @Default(<String>["Action", "Open", "Save"]) List<String> options,
    @Default("Action") String currentOption,
  }) = _TipOption;
}
