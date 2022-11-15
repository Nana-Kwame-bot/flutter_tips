import 'dart:io';

import 'package:flutter_tips/main.dart';
import 'package:flutter_tips/saved_tips/saved_tips.model.dart';
import 'package:flutter_tips/tip_details/models/current_saved_tip/current_saved_tip.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tips_repository/tips_repository.dart';

part 'saved_tips_notifier.g.dart';

@riverpod
class SavedTipsNotifier extends _$SavedTipsNotifier {
  @override
  SavedTips build() {
    return const SavedTips();
  }

  void addLatestTip({required CurrentSavedTip currentSavedTip}) {
    currentSavedTip.maybeWhen(
      loaded: (data) {
        if (!state.savedTips.contains(data)) {
          state = state.copyWith(savedTips: [...state.savedTips, data]);
          logger.i("Saved tip: $state");
        }
      },
      orElse: () {
        logger.i("Error saving tip");
      },
    );
  }

  Future<void> removeTip({required SavedTip savedTip}) async {
    final codeResult = await _deleteFile(path: savedTip.codePath);
    final imageResult = await _deleteFile(path: savedTip.imagePath);

    logger
      ..i("codeResult: $codeResult")
      ..i("imageResult: $imageResult");

    state = state.copyWith(
      savedTips: [
        for (final tip in state.savedTips)
          if (tip.title != savedTip.title) savedTip,
      ],
    );
  }
}

Future<String> _deleteFile({required String path}) async {
  try {
    final file = File(path);

    await file.delete();
    return "File deleted";
  } catch (e) {
    // If encountering an error
    return "Unable to delete file";
  }
}

// final savedTipsProvider =
//     StateNotifierProvider<SavedTipsNotifier, SavedTips>((ref) {
//   return SavedTipsNotifier();
// });

// class SavedTipsNotifier extends StateNotifier<SavedTips> {
//   SavedTipsNotifier() : super(const SavedTips());

//   void addLatestTip({required CurrentSavedTip currentSavedTip}) {
//     currentSavedTip.maybeWhen(
//       loaded: (data) {
//         if (!state.savedTips.contains(data)) {
//           state = state.copyWith(savedTips: [...state.savedTips, data]);
//           logger.i("Saved tip: $state");
//         }
//       },
//       orElse: () {
//         logger.i("Error saving tip");
//       },
//     );
//   }

//   Future<void> removeTip({required SavedTip savedTip}) async {
//     final codeResult = await _deleteFile(path: savedTip.codePath);
//     final imageResult = await _deleteFile(path: savedTip.imagePath);

//     logger
//       ..i("codeResult: $codeResult")
//       ..i("imageResult: $imageResult");

//     state = state.copyWith(
//       savedTips: [
//         for (final tip in state.savedTips)
//           if (tip.title != savedTip.title) savedTip,
//       ],
//     );
//   }
// }

// Future<String> _deleteFile({required String path}) async {
//   try {
//     final file = File(path);

//     await file.delete();
//     return "File deleted";
//   } catch (e) {
//     // If encountering an error
//     return "Unable to delete file";
//   }
// }
