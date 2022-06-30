import 'dart:convert';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tips/home/view/home_page.dart';
import 'package:macos_ui/macos_ui.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _pageIndex = 0;

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
                final window = await DesktopMultiWindow.createWindow(jsonEncode(
                  {
                    'args1': 'About Flutter Tips',
                    'args2': 500,
                    'args3': true,
                  },
                ));
                debugPrint('$window');
                window
                  ..setFrame(const Offset(0, 0) & const Size(350, 350))
                  ..center()
                  ..setTitle('About Flutter Tips')
                  ..show();
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
          builder: (context, scrollController) => SidebarItems(
            currentIndex: _pageIndex,
            onChanged: (index) {
              setState(() => _pageIndex = index);
            },
            items: const [
              SidebarItem(
                leading: MacosIcon(CupertinoIcons.home),
                label: Text('Home'),
              ),
            ],
          ),
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
