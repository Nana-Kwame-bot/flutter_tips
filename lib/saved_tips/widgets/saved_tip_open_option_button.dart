import 'package:flutter/cupertino.dart';
import 'package:flutter_tips/saved_tips/notifiers/saved_tips_notifier.dart';
import 'package:flutter_tips/tip_details/views/tip_details.dart';
import 'package:flutter_tips/tip_options/providers/providers.dart';
import 'package:flutter_tips/tips/notifiers/tips_search_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class SavedTipsOptionsButton extends ConsumerWidget {
  const SavedTipsOptionsButton({super.key, required this.index});

  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hoverList = ref.watch(savedTipsHoverNotifierProvider);
    final savedTips = ref.watch(savedTipsNotifierProvider).savedTips;

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
                ref.read(tipsSearchNotifierProvider.notifier).selectTip(
                      selectedTipTile: savedTips[index].title,
                    );
                context.goNamed(TipDetails.name);
              },
              label: "Open tip in new window",
            ),
            const MacosPulldownMenuDivider(),
            MacosPulldownMenuItem(
              title: const Text("Remove"),
              onTap: () {
                ref.read(savedTipsNotifierProvider.notifier).removeTip(
                      savedTip: savedTips[index],
                    );
              },
              label: "Remove tip",
            ),
          ],
        ),
      ),
    );
  }
}
