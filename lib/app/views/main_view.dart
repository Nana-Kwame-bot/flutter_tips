import 'dart:convert';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/app/providers/providers.dart';
import 'package:flutter_tips/main.dart';
import 'package:flutter_tips/tips/views/home_page.dart';
import 'package:flutter_tips/tips/views/saved_tips_page.dart';
import 'package:macos_ui/macos_ui.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  static const String name = "main_view";
  static const String path = "/";

  void _setWindow({required WindowController windowController}) {
    windowController
      ..setFrame(Offset.zero & const Size(350, 350))
      ..center()
      ..setTitle('About Flutter Tips')
      ..show();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: [
        PlatformMenu(
          label: 'FlutterTips',
          menus: [
            PlatformMenuItem(
              label: 'About',
              onSelected: () async {
                final window = await DesktopMultiWindow.createWindow(
                  jsonEncode(
                    {
                      'args1': 'About Flutter Tips',
                      'args2': 500,
                      'args3': true,
                    },
                  ),
                );
                logger.d('${window.runtimeType}');
                _setWindow(windowController: window);
              },
            ),
            const PlatformProvidedMenuItem(
              type: PlatformProvidedMenuItemType.quit,
            ),
          ],
        ),
      ],
      body: Consumer(
        builder: (context, ref, child) {
          final _pageIndex = ref.watch(pageIndexProvider);

          return MacosWindow(
            sidebar: Sidebar(
              minWidth: 200,
              builder: (context, scrollController) {
                return SidebarItems(
                  currentIndex: _pageIndex,
                  onChanged: (index) {
                    ref.read(pageIndexProvider.notifier).update(
                          (_) => index,
                        );
                  },
                  items: const [
                    SidebarItem(
                      leading: MacosIcon(CupertinoIcons.home),
                      label: Text("Home"),
                    ),
                    SidebarItem(
                      leading: MacosIcon(CupertinoIcons.floppy_disk),
                      label: Text("Saved Tips"),
                    ),
                  ],
                );
              },
            ),
            child: IndexedStack(
              index: _pageIndex,
              children: const [
                HomePage(),
                SavedTipsPage(),
              ],
            ),
          );
        },
      ),
    );
  }
}
