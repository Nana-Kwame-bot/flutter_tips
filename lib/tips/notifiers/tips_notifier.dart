import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/tips/models/tip_state/tips_state.model.dart';
import 'package:flutter_tips/tips/providers/providers.dart';
import 'package:tips_repository/tips_repository.dart';
import 'package:tuple/tuple.dart';

final tipsProvider = StateNotifierProvider<TipsNotifier, TipsState>(
  (ref) {
    return TipsNotifier(tipsRepository: ref.read(tipsRepositoryProvider));
  },
  name: "TipsNotifier",
);

class TipsNotifier extends StateNotifier<TipsState> {
  TipsNotifier({required TipsRepository tipsRepository})
      : _tipsRepository = tipsRepository,
        super(const TipsState.initial());

  final TipsRepository _tipsRepository;

  Future<void> getData() async {
    state = const TipsState.loading();

    final data = await AsyncValue.guard(_tipsRepository.getTips);

    data.when<void>(
      data: (data) {
        state = TipsState.loaded(tips: data, currentItemCount: 9);
      },
      error: (object, stackTrace) {
        state = TipsState.error(error: object, stackTrace: stackTrace);
      },
      loading: () {
        state = const TipsState.loading();
      },
    );
  }

  void loadMore() {
    final stateItems = state.whenOrNull(
      loaded: (tips, itemCount) {
        return Tuple2(tips, itemCount);
      },
    )!;

    final tips = stateItems.item1;
    final totalItemCount = tips.length;
    var currentItemCount = stateItems.item2;

    if (currentItemCount < totalItemCount) {
      if (totalItemCount - currentItemCount <= 9) {
        state = TipsState.loaded(
          tips: tips,
          currentItemCount: totalItemCount - currentItemCount,
        );
        return;
      }
      currentItemCount = currentItemCount + 9;
      state = TipsState.loaded(
        tips: tips,
        currentItemCount: currentItemCount,
      );
    }
  }
}
