import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:tips_repository/tips_repository.dart';

class TipsSearchNotifier extends StateNotifier<Tip> {
  TipsSearchNotifier({
    required this.currentTips,
  }) : super(const Tip(imageUrl: "", codeUrl: "", title: ""));

  final List<Tip> currentTips;

  void selectTip({required SearchResultItem searchResultItem}) {
    for (var element in currentTips) {
      if (element.title == searchResultItem.searchKey) {
        state = Tip(
          imageUrl: element.imageUrl,
          codeUrl: element.codeUrl,
          title: element.title,
        );
        return;
      }
    }
  }
}
