import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:tips_repository/tips_repository.dart';

class TipsSearchNotifier extends StateNotifier<Tip> {
  TipsSearchNotifier({
    required this.currentTips,
  }) : super(const Tip(imageUrl: "", codeUrl: "", title: ""));

  final List<Tip> currentTips;

  void selectTip({
    SearchResultItem? searchResultItem,
    String? selectedTipTile,
  }) {
    if (searchResultItem != null) {
      state = currentTips.firstWhere(
        (tip) => tip.title == searchResultItem.searchKey,
        orElse: () => Tip(
          imageUrl: currentTips.first.imageUrl,
          codeUrl: currentTips.first.codeUrl,
          title: currentTips.first.title,
        ),
      );
      return;
    }
    assert(selectedTipTile != null);
    if (selectedTipTile != null) {
      state = currentTips.firstWhere(
        (tip) => tip.title == selectedTipTile,
        orElse: () => Tip(
          imageUrl: currentTips.first.imageUrl,
          codeUrl: currentTips.first.codeUrl,
          title: currentTips.first.title,
        ),
      );
      return;
    }
  }
}
