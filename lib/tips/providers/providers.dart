import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/tips/notifier/tips_notifier.dart';
import 'package:flutter_tips/tips/state/tips_state.dart';
import 'package:tips_and_tricks_api/tips_and_tricks_api.dart';
import 'package:tips_repository/tips_repository.dart';

final _tipsAndTricksDataProvider = Provider<TipsAndTricksApiClient>(
  (ref) {
    return TipsAndTricksApiClient();
  },
  name: "TipsAndTricksApiClient",
);

final _tipsRepositoryProvider = Provider<TipsRepository>(
  (ref) {
    return TipsRepository(
      tipsAndTricksApiClient: ref.watch(_tipsAndTricksDataProvider),
    );
  },
  name: "TipsRepository",
);

final tipsNotifierProvider = StateNotifierProvider<TipsNotifier, TipsState>(
  (ref) {
    return TipsNotifier(tipsRepository: ref.watch(_tipsRepositoryProvider));
  },
  name: "TipsNotifier",
);
