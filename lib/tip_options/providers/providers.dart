import 'package:flutter_tips/saved_tips/notifiers/saved_tips_notifier.dart';
import 'package:flutter_tips/tips/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
class SavedTipsHoverNotifier extends _$SavedTipsHoverNotifier {
  @override
  List<bool> build() {
    final currentTipsLength =
        ref.watch(savedTipsNotifierProvider).savedTips.length;

    return List.filled(currentTipsLength, false);
  }

  void update({required int index}) {
    final hoverList = List.of(state);

    hoverList[index] = true;

    state = hoverList;
  }
}

@riverpod
class TipHoverNotifier extends _$TipHoverNotifier {
  @override
  List<bool> build() {
    final currentTipsLength = ref.watch(currentTipsProvider).length;

    return List.filled(currentTipsLength, false);
  }

  void update({required int index}) {
    final hoverList = List.of(state);

    hoverList[index] = true;

    state = hoverList;
  }
}
