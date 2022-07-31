import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/tips/notifiers/tips_notifier.dart';
import 'package:flutter_tips/tips/notifiers/tips_search_notifier.dart';
import 'package:flutter_tips/tips/state/tips_state.dart';
import 'package:tips_and_tricks_api/tips_and_tricks_api.dart';
import 'package:tips_repository/tips_repository.dart';

final _tipsAndTricksDataProvider = Provider<TipsAndTricksApiClient>(
  (ref) {
    return TipsAndTricksApiClient();
  },
  name: "TipsAndTricksApiClient",
);

final tipsRepositoryProvider = Provider<TipsRepository>(
  (ref) {
    return TipsRepository(
      tipsAndTricksApiClient: ref.watch(_tipsAndTricksDataProvider),
    );
  },
  name: "TipsRepository",
);

final tipsProvider = StateNotifierProvider<TipsNotifier, AsyncValue<TipsState>>(
  (ref) {
    return TipsNotifier(tipsRepository: ref.read(tipsRepositoryProvider));
  },
  name: "TipsNotifier",
);

final currentTipsProvider = Provider<List<Tip>>(
  (ref) {
    final currentTips = ref.watch(tipsProvider).whenOrNull<List<Tip>>(
      data: (data) {
        return data.tips.take(data.currentItemCount).toList();
      },
    )!;

    return currentTips;
  },
  name: "CurrentTips",
);

final allTipsProvider = Provider<List<Tip>>((ref) {
  final allTips = ref.watch(tipsProvider).whenOrNull<List<Tip>>(
    data: (data) {
      return data.tips;
    },
  )!;
  return allTips;
});

final tipsSearchProvider =
    StateNotifierProvider.autoDispose<TipsSearchNotifier, Tip>(
  (ref) {
    final allTips = ref.watch(allTipsProvider);
    return TipsSearchNotifier(allTips: allTips);
  },
  name: "TipsSearchNotifier",
);
