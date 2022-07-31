import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/tip_details/view/tip_details.dart';
import 'package:flutter_tips/tips/providers/providers.dart';
import 'package:go_router/go_router.dart';
import 'package:macos_ui/macos_ui.dart';

class TipsSearchField extends ConsumerWidget {
  const TipsSearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipsState = ref.watch(tipsProvider);
    final allTips = tipsState.whenOrNull(
      data: (data) {
        return data.tips;
      },
    )!;
    return MacosSearchField<String>(
      maxLines: 1,
      maxResultsToShow: 15,
      results: allTips.map((e) {
        return SearchResultItem(e.title);
      }).toList(),
      onResultSelected: (searchResultItem) {
        ref.read(tipsSearchProvider.notifier).selectTip(
              searchResultItem: searchResultItem,
            );
        context.goNamed(TipDetails.name);
      },
      placeholder: "Search for a tip...",
    );
  }
}
