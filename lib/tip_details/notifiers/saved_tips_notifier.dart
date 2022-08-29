import 'package:flutter_tips/main.dart';
import 'package:flutter_tips/tips/models/tip_state_list/tip_state_list.model.dart';
import 'package:hydrated_riverpod/hydrated_riverpod.dart';
import 'package:tips_repository/tips_repository.dart';

class SavedTipsNotifier extends HydratedStateNotifier<TipStateList> {
  SavedTipsNotifier({required this.latestTip}) : super(const TipStateList()) {
    _addLatestTip();
  }

  final SavedTip? latestTip;

  void _addLatestTip() {
    if (latestTip == null) {
      logger.i("Tip is null");

      return;
    }
    logger.i(
      "Tip: $latestTip saved Codepath: ${latestTip!.codePath} Imagepath: ${latestTip!.imagePath}",
    );

    state = state.copyWith(savedTips: [...state.savedTips, latestTip!]);
    logger.i("Saved tips: $state");
  }

  @override
  TipStateList? fromJson(Map<String, dynamic> json) {
    return TipStateList.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(TipStateList state) {
    return state.toJson();
  }
}
