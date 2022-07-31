import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/tip_options/model/tip_option.model.dart';
import 'package:flutter_tips/tip_options/notifiers/tip_option_notifier.dart';
import 'package:flutter_tips/tips/providers/providers.dart';

final tipOptionProvider = StateNotifierProvider<TipOptionNotifier, TipOption>(
  (ref) {
    return TipOptionNotifier();
  },
  name: "TipOptionProvider",
);

final tipHoverProvider = StateProvider<List<bool>>(
  (ref) {
    final currentTipsLength = ref.watch(currentTipsProvider).length;
    return List.filled(currentTipsLength, false);
  },
  name: "TipHoverProvider",
);
