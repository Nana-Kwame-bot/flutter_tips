import 'package:flutter_tips/tips/models/tip_state/tips_state.model.dart';
import 'package:flutter_tips/tips/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuple/tuple.dart';

part 'tips_notifier.g.dart';

@Riverpod(keepAlive: true)
class TipsNotifier extends _$TipsNotifier {
  @override
  TipsState build() {
    return const TipsState.initial();
  }

  Future<void> getData() async {
    final tipsRepository = ref.read(tipsRepositoryProvider);

    state = const TipsState.loading();

    final data = await AsyncValue.guard(tipsRepository.getTips);

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
