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
    final tips = ref.watch(tipsProvider).whenOrNull<List<Tip>>(
      data: (data) {
        return data.tips.take(data.currentItemCount).toList();
      },
    )!;

    return tips;
  },
  name: "CurrentTips",
);

final tipsSearchProvider = StateNotifierProvider<TipsSearchNotifier, Tip>(
  (ref) {
    final currentTips = ref.watch(currentTipsProvider);
    return TipsSearchNotifier(currentTips: currentTips);
  },
  name: "TipsSearchNotifier",
);
