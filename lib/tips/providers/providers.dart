import 'package:flutter_tips/tips/notifiers/tips_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tips_and_tricks_api/tips_and_tricks_api.dart';
import 'package:tips_repository/tips_repository.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
TipsAndTricksApiClient tipsAndTricksData(TipsAndTricksDataRef ref) {
  return TipsAndTricksApiClient();
}

@Riverpod(keepAlive: true)
TipsRepository tipsRepository(TipsRepositoryRef ref) {
  return TipsRepository(
    tipsAndTricksApiClient: ref.watch(tipsAndTricksDataProvider),
  );
}

@riverpod
List<Tip> currentTips(CurrentTipsRef ref) {
  final currentTips = ref.watch(tipsNotifierProvider).whenOrNull<List<Tip>>(
    loaded: (data, itemCount) {
      return data.take(itemCount).toList();
    },
  )!;

  return currentTips;
}

@Riverpod(keepAlive: true)
List<Tip> alltips(AlltipsRef ref) {
  final allTips = ref.watch(tipsNotifierProvider).whenOrNull<List<Tip>>(
    loaded: (data, _) {
      return data;
    },
  )!;
  return allTips;
}
