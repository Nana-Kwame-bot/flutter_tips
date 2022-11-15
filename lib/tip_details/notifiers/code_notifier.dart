import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_tips/tip_details/models/code_string/code_string.model.dart';
import 'package:flutter_tips/tips/notifiers/tips_search_notifier.dart';
import 'package:flutter_tips/tips/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'code_notifier.g.dart';

// final codeProvider =
//     StateNotifierProvider.autoDispose<CodeNotifier, CodeString>(
//   (ref) {
//     // An object from package:dio that allows cancelling http requests
//     final cancelToken = CancelToken();
//     // When the provider is destroyed, cancel the http request
//     ref.onDispose(cancelToken.cancel);

//     final selectedTip = ref.watch(tipsSearchProvider);

//     final tipsRepository = ref.read(tipsRepositoryProvider);

//     // If the request completed successfully, keep the state
//     ref.keepAlive();

//     return CodeNotifier(
//       selectedTip: selectedTip,
//       cancelToken: cancelToken,
//       tipsRepository: tipsRepository,
//     );
//   },
//   name: "CodeNotifier",
// );

@riverpod
class CodeNotifier extends _$CodeNotifier {
  @override
  CodeString build({required CancelToken cancelToken}) {
    return const CodeString.loading();
  }

  Future<void> getCodeString() async {
    final codeFilePath = await _getTempFilePath();

    codeFilePath.when<void>(
      data: (path) async {
        final codeString = await _readCodeFile(path: path);

        final splitString = codeString.split("\n")
          ..removeWhere((element) => element.startsWith("//"));
        state = CodeString.loaded(codeString: splitString.join("\n"));
      },
      error: (error, stackTrace) {
        state = CodeString.error(error: error, stackTrace: stackTrace);
      },
      loading: () {
        state = const CodeString.loading();
      },
    );
  }

  Future<AsyncValue<String>> _getTempFilePath() async {
    final selectedTip = ref.watch(tipsSearchNotifierProvider);

    final tipsRepository = ref.read(tipsRepositoryProvider);

    final fileName = selectedTip.codeUrl.split("/").last;

    final codePath = await AsyncValue.guard(() {
      return tipsRepository.getTempPathAndSaveCodeTemporarily(
        codeUrl: selectedTip.codeUrl,
        fileName: fileName,
        cancelToken: cancelToken,
      );
    });

    return codePath;
  }

  Future<String> _readCodeFile({required String path}) async {
    try {
      final file = File(path);
      // Read the file as a string
      return await file.readAsString();
    } catch (e) {
      // If encountering an error
      return "Code not available";
    }
  }
}
