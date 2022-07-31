import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/tips/state/tips_state.dart';
import 'package:tips_repository/tips_repository.dart';
import 'package:tuple/tuple.dart';

class TipsNotifier extends StateNotifier<AsyncValue<TipsState>> {
  TipsNotifier({
    required TipsRepository tipsRepository,
  })  : _tipsRepository = tipsRepository,
        super(const AsyncValue.loading()) {
    getData();
  }

  final TipsRepository _tipsRepository;

  Future<void> getData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final tips = await _tipsRepository.getTips();

      return TipsState(tips: tips, currentItemCount: 9);
    });
  }

  void loadMore() {
    final stateItems = state.whenOrNull(
      data: (data) {
        return Tuple2(data.tips, data.currentItemCount);
      },
    )!;

    final tips = stateItems.item1;
    final totalItemCount = tips.length;
    var currentItemCount = stateItems.item2;

    if (currentItemCount < totalItemCount) {
      if (totalItemCount - currentItemCount <= 9) {
        state = AsyncValue.data(
          TipsState(
            currentItemCount: totalItemCount - currentItemCount,
            tips: tips,
          ),
        );
      }
      currentItemCount = currentItemCount + 9;
      state = AsyncValue.data(
        TipsState(
          tips: tips,
          currentItemCount: currentItemCount,
        ),
      );
    }
  }
}
