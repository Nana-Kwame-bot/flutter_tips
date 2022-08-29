import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/main.dart';
import 'package:flutter_tips/tip_details/notifiers/code_notifier.dart';
import 'package:flutter_tips/tip_details/notifiers/save_code_temp_notifier.dart';
import 'package:flutter_tips/tip_details/notifiers/save_tip.dart';
import 'package:flutter_tips/tip_details/notifiers/saved_tips_notifier.dart';
import 'package:flutter_tips/tips/models/tip_state_list/tip_state_list.model.dart';
import 'package:flutter_tips/tips/providers/providers.dart';
import 'package:tips_repository/tips_repository.dart';

final _saveCodeTempProvider = StateNotifierProvider.autoDispose<
    SaveCodeFileTempNotifier, AsyncValue<String>>(
  (ref) {
    // An object from package:dio that allows cancelling http requests
    final cancelToken = CancelToken();
    // When the provider is destroyed, cancel the http request
    ref.onDispose(cancelToken.cancel);

    final selectedTip = ref.watch(tipsSearchProvider);

    final tipsRepository = ref.read(tipsRepositoryProvider);

    // If the request completed successfully, keep the state
    ref.keepAlive();

    return SaveCodeFileTempNotifier(
      selectedTip: selectedTip,
      cancelToken: cancelToken,
      tipsRepository: tipsRepository,
    );
  },
  name: "SaveCodeFileTempNotifier",
);

final codeProvider =
    StateNotifierProvider.autoDispose<CodeNotifier, AsyncValue<String>>(
  (ref) {
    final state = ref.watch(_saveCodeTempProvider);

    final filePath = state.maybeWhen(
      data: (data) {
        return data;
      },
      orElse: () {
        return "";
      },
    );

    // If the request completed successfully, keep the state
    ref.keepAlive();

    return CodeNotifier(
      codeFilePath: filePath,
    );
  },
  name: "CodeNotifier",
);

final savedTipProvider =
    StateNotifierProvider.autoDispose<SaveTipNotifier, AsyncValue<SavedTip>>(
        (ref) {
  final selectedTip = ref.watch(tipsSearchProvider);
  final tipsRepository = ref.read(tipsRepositoryProvider);
  // An object from package:dio that allows cancelling http requests
  final cancelToken = CancelToken();
  ref.keepAlive();

  return SaveTipNotifier(
    selectedTip: selectedTip,
    tipsRepository: tipsRepository,
    cancelToken: cancelToken,
  );
});

final savedTipsProvider =
    StateNotifierProvider.autoDispose<SavedTipsNotifier, TipStateList>((ref) {
  ref.keepAlive();

  final latestTip = ref.watch(savedTipProvider).when<SavedTip?>(
    data: (data) {
      return data;
    },
    error: (error, stackTrace) {
      logger.e("Latest tip is null Error: $error \nStackTrace: $stackTrace");

      return null;
    },
    loading: () {
      return null;
    },
  );

  return SavedTipsNotifier(latestTip: latestTip);
});
