import 'package:dio/dio.dart';
import 'package:flutter_tips/saved_tips/notifiers/saved_tips_notifier.dart';
import 'package:flutter_tips/tip_details/models/current_saved_tip/current_saved_tip.model.dart';
import 'package:flutter_tips/tips/notifiers/tips_search_notifier.dart';
import 'package:flutter_tips/tips/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saved_tip_notifier.g.dart';

@riverpod
class SaveTipNotifier extends _$SaveTipNotifier {
  @override
  CurrentSavedTip build() {
    return const CurrentSavedTip.initial();
  }

  Future<void> saveTip() async {
    final selectedTip = ref.watch(tipsSearchNotifierProvider);
    final tipsRepository = ref.read(tipsRepositoryProvider);
    final cancelToken = CancelToken();

    final codeFileName = selectedTip.codeUrl.split("/").last;
    final imageFileName = selectedTip.imageUrl.split("/").last;

    state = const CurrentSavedTip.loading();

    final savedTip = await AsyncValue.guard(() async {
      return tipsRepository.saveTipPermanently(
        codeUrl: selectedTip.codeUrl,
        imageUrl: selectedTip.imageUrl,
        codeFileName: codeFileName,
        imageFileName: imageFileName,
        cancelToken: cancelToken,
        title: selectedTip.title,
      );
    });

    savedTip.when<void>(
      data: (data) {
        state = CurrentSavedTip.loaded(savedTip: data);

        ref
            .read(savedTipsNotifierProvider.notifier)
            .addLatestTip(currentSavedTip: state);
      },
      error: (error, stackTrace) {
        state = CurrentSavedTip.error(error: error, stackTrace: stackTrace);
      },
      loading: () {
        state = const CurrentSavedTip.loading();
      },
    );
  }
}
