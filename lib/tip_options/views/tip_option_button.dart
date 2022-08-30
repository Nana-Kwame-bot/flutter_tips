import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/tip_details/notifiers/saved_tip_notifier.dart';
import 'package:flutter_tips/tip_details/view/tip_details.dart';
import 'package:flutter_tips/tip_options/providers/providers.dart';
import 'package:flutter_tips/tips/notifiers/tips_search_notifier.dart';
import 'package:flutter_tips/tips/providers/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:macos_ui/macos_ui.dart';

class TipOptionButton extends ConsumerWidget {
  const TipOptionButton({super.key, required this.index});

  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hoverList = ref.watch(tipHoverProvider);
    final currentTips = ref.watch(currentTipsProvider);
    return Positioned(
      top: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: hoverList[index] ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 150),
        child: MacosPulldownButton(
          icon: CupertinoIcons.ellipsis_circle,
          items: [
            MacosPulldownMenuItem(
              title: const Text("Open"),
              onTap: () {
                ref.read(tipsSearchProvider.notifier).selectTip(
                      selectedTipTile: currentTips[index].title,
                    );
                context.goNamed(TipDetails.name);
              },
              label: "Open tip in new window",
            ),
            const MacosPulldownMenuDivider(),
            MacosPulldownMenuItem(
              title: const Text("Save"),
              onTap: () {
                ref.read(tipsSearchProvider.notifier).selectTip(
                      selectedTipTile: currentTips[index].title,
                    );
                ref.read(savedTipProvider.notifier).saveTip();
              },
              label: "Save tip",
            ),
          ],
        ),
      ),
    );
  }
}
