import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/tips/notifiers/tips_notifier.dart';
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

final currentTipsProvider = Provider<List<Tip>>(
  (ref) {
    final currentTips = ref.watch(tipsProvider).whenOrNull<List<Tip>>(
      loaded: (data, itemCount) {
        return data.take(itemCount).toList();
      },
    )!;

    return currentTips;
  },
  name: "CurrentTips",
);

final allTipsProvider = Provider<List<Tip>>(
  (ref) {
    final allTips = ref.watch(tipsProvider).whenOrNull<List<Tip>>(
      loaded: (data, _) {
        return data;
      },
    )!;
    return allTips;
  },
  name: "All Tips",
);
