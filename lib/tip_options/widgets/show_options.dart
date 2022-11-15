import 'package:flutter/widgets.dart';
import 'package:flutter_tips/tip_options/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShowOptions extends ConsumerWidget {
  const ShowOptions({required this.child, required this.index, super.key});

  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      onEnter: (event) {
        ref.read(tipHoverNotifierProvider.notifier).update(index: index);
      },
      onExit: (event) {
        ref.read(tipHoverNotifierProvider.notifier).update(index: index);
      },
      opaque: false,
      child: child,
    );
  }
}
