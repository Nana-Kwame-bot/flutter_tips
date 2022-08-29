import "package:flutter/cupertino.dart";
import "package:macos_ui/macos_ui.dart";

class SavedTipsPage extends StatelessWidget {
  const SavedTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (context) {
        return MacosScaffold(
          toolBar: ToolBar(
            title: const Text("Saved Tips"),
            actions: [
              ToolBarIconButton(
                label: "Toggle Sidebar",
                icon: const MacosIcon(CupertinoIcons.sidebar_left),
                showLabel: false,
                tooltipMessage: "Toggle Sidebar",
                onPressed: () {
                  MacosWindowScope.of(context).toggleSidebar();
                },
              ),
            ],
          ),
          children: [
            ContentArea(
              builder: (context, scrollController) {
                return const Text("TODO");
              },
            ),
          ],
        );
      },
    );
  }
}
