import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:tips_repository/tips_repository.dart';

class TipsSearchNotifier extends StateNotifier<Tip> {
  TipsSearchNotifier({
    required this.allTips,
  }) : super(const Tip(imageUrl: "", codeUrl: "", title: ""));

  final List<Tip> allTips;

  void selectTip({
    SearchResultItem? searchResultItem,
    String? selectedTipTile,
  }) {
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
