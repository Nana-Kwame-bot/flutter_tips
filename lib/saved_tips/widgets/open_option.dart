import 'package:flutter/material.dart';
import 'package:flutter_tips/tip_options/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SavedTipOptions extends ConsumerWidget {
  const SavedTipOptions({required this.child, required this.index, super.key});

  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      onEnter: (event) {
        ref.read(savedTipsHoverNotifierProvider.notifier).update(index: index);
      },
      onExit: (event) {
        ref.read(savedTipsHoverNotifierProvider.notifier).update(index: index);
      },
      opaque: false,
      child: child,
    );
  }
}
