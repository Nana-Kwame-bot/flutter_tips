import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/tip_options/model/tip_option.model.dart';

class TipOptionNotifier extends StateNotifier<TipOption> {
  TipOptionNotifier() : super(const TipOption());

  void onTipOptionChanged({required String newOption}) {
    state = state.copyWith(currentOption: newOption);
  }
}
