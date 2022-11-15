import 'package:flutter_tips/tips/providers/providers.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tips_repository/tips_repository.dart';

part 'tips_search_notifier.g.dart';

@Riverpod(keepAlive: true)
class TipsSearchNotifier extends _$TipsSearchNotifier {
  @override
  Tip build() {
    return const Tip(imageUrl: "", codeUrl: "", title: "");
  }

  void selectTip({
    SearchResultItem? searchResultItem,
    String? selectedTipTile,
  }) {
    final allTips = ref.watch(alltipsProvider);

    if (searchResultItem != null) {
      state = allTips.firstWhere(
        (tip) => tip.title == searchResultItem.searchKey,
        orElse: () => Tip(
          imageUrl: allTips.first.imageUrl,
          codeUrl: allTips.first.codeUrl,
          title: allTips.first.title,
        ),
      );

      return;
    }
    assert(selectedTipTile != null, "selectedTipTile is not null");
    if (selectedTipTile != null) {
      state = allTips.firstWhere(
        (tip) => tip.title == selectedTipTile,
        orElse: () => Tip(
          imageUrl: allTips.first.imageUrl,
          codeUrl: allTips.first.codeUrl,
          title: allTips.first.title,
        ),
      );
      return;
    }
  }
}
