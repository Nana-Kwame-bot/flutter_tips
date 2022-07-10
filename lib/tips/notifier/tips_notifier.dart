import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/main.dart';
import 'package:flutter_tips/tips/state/tips_state.dart';
import 'package:tips_and_tricks_api/tips_and_tricks_api.dart';
import 'dart:async';
import 'package:tips_repository/tips_repository.dart';
import 'package:tuple/tuple.dart';

class TipsNotifier extends StateNotifier<TipsState> {
  TipsNotifier({
    required TipsRepository tipsRepository,
  })  : _tipsRepository = tipsRepository,
        super(const TipsState.initial());

  final TipsRepository _tipsRepository;

  Future<void> getData() async {
    try {
      state = const TipsState.loadInProgress();
      final tips = await _tipsRepository.getTips();
      state = TipsState.loadSuccess(tips: tips, currentItemCount: 9);
      logger.i(tips.first);
    } on DioException catch (e) {
      state = TipsState.loadFailure(errorMessage: e.errorMessage);
    } catch (_) {
      state = const TipsState.loadFailure();
    }
  }

  void loadMore() {
    Tuple2<List<TipUrl>, int> stateItems = state.whenOrNull(
      loadSuccess: (
        tips,
        currentItemCount,
      ) {
        return Tuple2(tips, currentItemCount);
      },
    )!;

    var tips = stateItems.item1;
    var totalItemCount = tips.length;
    var currentItemCount = stateItems.item2;

    if (currentItemCount < totalItemCount) {
      if (totalItemCount - currentItemCount <= 9) {
        state = TipsState.loadSuccess(
          currentItemCount: (totalItemCount - currentItemCount),
          tips: tips,
        );
      }
      currentItemCount = currentItemCount + 9;
      state =
          TipsState.loadSuccess(tips: tips, currentItemCount: currentItemCount);
    }
  }
}
