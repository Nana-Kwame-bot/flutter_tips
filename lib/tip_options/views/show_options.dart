import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/tip_options/providers/providers.dart';

class ShowOptions extends ConsumerWidget {
  const ShowOptions({required this.child, required this.index, super.key});

  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      onEnter: (event) {
        ref.read(tipHoverProvider.notifier).update((state) {
          final hoverList = List.of(state);

          hoverList[index] = true;

          return hoverList;
        });
      },
      onExit: (event) {
        ref.read(tipHoverProvider.notifier).update((state) {
          final hoverList = List.of(state);

          hoverList[index] = false;

          return hoverList;
        });
      },
      opaque: false,
      child: child,
    );
  }
}
