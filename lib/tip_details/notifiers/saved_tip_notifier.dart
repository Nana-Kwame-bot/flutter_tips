import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/main.dart';
import 'package:flutter_tips/tip_details/models/current_saved_tip/current_saved_tip.model.dart';
import 'package:flutter_tips/tip_details/notifiers/saved_tips_notifier.dart';
import 'package:flutter_tips/tips/notifiers/tips_search_notifier.dart';
import 'package:flutter_tips/tips/providers/providers.dart';
import 'package:tips_repository/tips_repository.dart';

final savedTipProvider =
    StateNotifierProvider.autoDispose<SaveTipNotifier, CurrentSavedTip>((ref) {
  final selectedTip = ref.watch(tipsSearchProvider);
  final tipsRepository = ref.read(tipsRepositoryProvider);
  // An object from package:dio that allows cancelling http requests
  final cancelToken = CancelToken();
  ref.keepAlive();

  return SaveTipNotifier(
    selectedTip: selectedTip,
    tipsRepository: tipsRepository,
    cancelToken: cancelToken,
    ref: ref,
  );
});

class SaveTipNotifier extends StateNotifier<CurrentSavedTip> {
  SaveTipNotifier({
    required TipsRepository tipsRepository,
    required this.selectedTip,
    required this.cancelToken,
    required this.ref,
  })  : _tipsRepository = tipsRepository,
        super(const CurrentSavedTip.loading());

  final TipsRepository _tipsRepository;
  final Tip selectedTip;
  final CancelToken cancelToken;
  final Ref ref;

  Future<void> saveTip() async {
    final codeFileName = selectedTip.codeUrl.split("/").last;
    final imageFileName = selectedTip.imageUrl.split("/").last;

    state = const CurrentSavedTip.loading();

    final savedTip = await AsyncValue.guard(() async {
      return _tipsRepository.saveTipPermanently(
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
        logger.i("Saved tip: $data");

        state = CurrentSavedTip.loaded(savedTip: data);

        ref
            .read(savedTipsProvider.notifier)
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
