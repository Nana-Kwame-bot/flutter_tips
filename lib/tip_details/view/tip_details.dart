import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/tip_details/widgets/code_tab.dart';
import 'package:flutter_tips/tip_details/widgets/image_tab.dart';
import 'package:macos_ui/macos_ui.dart';

class TipDetails extends ConsumerWidget {
  const TipDetails({super.key});

  static const String name = "tip_details";
  static const String path = "tip_details";

  static Route<void> route() {
    return CupertinoPageRoute(
      builder: (context) {
        return const TipDetails();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text(
          "Details",
        ),
        actions: [
          ToolBarIconButton(
            label: 'Toggle Sidebar',
            icon: const MacosIcon(CupertinoIcons.sidebar_left),
            showLabel: false,
            tooltipMessage: 'Toggle Sidebar',
            onPressed: () {
              MacosWindowScope.of(context).toggleSidebar();
            },
          ),
        ],
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: MacosTabView(
                controller: MacosTabController(length: 2),
                tabs: const [
                  MacosTab(label: "Image"),
                  MacosTab(label: "Code"),
                ],
                children: const [
                  ImageTab(),
                  CodeTab(),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
