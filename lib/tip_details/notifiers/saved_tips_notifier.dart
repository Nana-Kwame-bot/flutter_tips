import 'package:flutter_tips/main.dart';
import 'package:flutter_tips/tip_details/models/current_saved_tip/current_saved_tip.model.dart';
import 'package:flutter_tips/tip_details/models/tip_state_list/tip_state_list.model.dart';
import 'package:hydrated_riverpod/hydrated_riverpod.dart';

final savedTipsProvider =
    StateNotifierProvider<SavedTipsNotifier, TipStateList>((ref) {
  return SavedTipsNotifier();
});

class SavedTipsNotifier extends StateNotifier<TipStateList> {
  SavedTipsNotifier() : super(const TipStateList());

  void addLatestTip({required CurrentSavedTip currentSavedTip}) {
    currentSavedTip.maybeWhen(
      loaded: (data) {
        state = state.copyWith(savedTips: [...state.savedTips, data]);

        logger.i("Saved tip: $state");
      },
      orElse: () {
        logger.i("Error saving tip");
      },
    );
  }
}
