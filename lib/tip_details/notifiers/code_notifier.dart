import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/main.dart';

class CodeNotifier extends StateNotifier<AsyncValue<String>> {
  CodeNotifier({
    required this.codeFilePath,
  }) : super(const AsyncValue.loading()) {
    getCodeString();
  }

  final String codeFilePath;

  Future<void> getCodeString() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final codeString = await _readCodeFile(path: codeFilePath);
      final splitString = codeString.split("\n");
      splitString.removeWhere((element) => element.startsWith("//"));
      // if (splitString.first.isEmpty) {
      //   splitString.removeAt(0);
      // }

      return splitString.join("\n");
    });
  }

  Future<String> _readCodeFile({required String path}) async {
    logger.i("Path: $path");

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
