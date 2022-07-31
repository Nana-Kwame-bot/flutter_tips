import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/main.dart';
import 'package:tips_repository/tips_repository.dart';

class SaveCodeFileTempNotifier extends StateNotifier<AsyncValue<String>> {
  SaveCodeFileTempNotifier({
    required TipsRepository tipsRepository,
    required this.cancelToken,
    required this.selectedTip,
  })  : _tipsRepository = tipsRepository,
        super(const AsyncValue.loading()) {
    saveCodeTemporarily();
  }

  final TipsRepository _tipsRepository;
  final Tip selectedTip;
  final CancelToken cancelToken;

  Future<void> saveCodeTemporarily() async {
    final fileName = selectedTip.codeUrl.split("/").last;
    logger.i("Filename: $fileName");
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return _tipsRepository.getTempPathAndSaveCodeTemporarily(
        codeUrl: selectedTip.codeUrl,
        fileName: fileName,
        cancelToken: cancelToken,
      );
    });
  }
}
