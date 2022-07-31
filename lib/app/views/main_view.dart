import 'dart:convert';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/main.dart';
import 'package:flutter_tips/tips/view/home_page.dart';
import 'package:macos_ui/macos_ui.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  static const String name = "main_view";
  static const String path = "/";

  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  int _pageIndex = 0;

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
      body: MacosWindow(
        sidebar: Sidebar(
          minWidth: 200,
          builder: (context, scrollController) {
            return SidebarItems(
              currentIndex: _pageIndex,
              onChanged: (index) {
                setState(() {
                  _pageIndex = index;
                });
              },
              items: const [
                SidebarItem(
                  leading: MacosIcon(CupertinoIcons.home),
                  label: Text('Home'),
                ),
              ],
            );
          },
        ),
        child: IndexedStack(
          index: _pageIndex,
          children: const [
            HomePage(),
          ],
        ),
      ),
    );
  }
}
