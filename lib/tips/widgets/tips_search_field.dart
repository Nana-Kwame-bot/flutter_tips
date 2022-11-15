import 'package:flutter/material.dart';
import 'package:flutter_tips/tip_details/views/tip_details.dart';
import 'package:flutter_tips/tips/notifiers/tips_notifier.dart';
import 'package:flutter_tips/tips/notifiers/tips_search_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class TipsSearchField extends ConsumerWidget {
  const TipsSearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipsState = ref.watch(tipsNotifierProvider);
    final allTips = tipsState.whenOrNull(
      loaded: (data, _) {
        return data;
      },
    )!;
    return MacosSearchField<String>(
      maxLines: 1,
      maxResultsToShow: 15,
      results: allTips.map((e) {
        return SearchResultItem(e.title);
      }).toList(),
      onResultSelected: (searchResultItem) {
        ref.read(tipsSearchNotifierProvider.notifier).selectTip(
              searchResultItem: searchResultItem,
            );
        context.goNamed(TipDetails.name);
      },
      placeholder: "Search for a tip...",
    );
  }
}
