import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/main.dart';
import 'package:tips_repository/tips_repository.dart';

class SaveTipNotifier extends StateNotifier<AsyncValue<SavedTip>> {
  SaveTipNotifier({
    required TipsRepository tipsRepository,
    required this.selectedTip,
    required this.cancelToken,
  })  : _tipsRepository = tipsRepository,
        super(const AsyncValue.loading());

  final TipsRepository _tipsRepository;
  final Tip selectedTip;
  final CancelToken cancelToken;

  Future<void> saveTip() async {
    final codeFileName = selectedTip.codeUrl.split("/").last;
    final imageFileName = selectedTip.imageUrl.split("/").last;

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final data = _tipsRepository.saveTipPermanently(
        codeUrl: selectedTip.codeUrl,
        imageUrl: selectedTip.imageUrl,
        codeFileName: codeFileName,
        imageFileName: imageFileName,
        cancelToken: cancelToken,
        title: selectedTip.title,
      );

      final tip = await data;

      logger.i("Saved tip: $tip");
      return data;
    });
  }
}
