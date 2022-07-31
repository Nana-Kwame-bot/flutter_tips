import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class AboutWindow extends StatelessWidget {
  const AboutWindow({
    super.key,
    required this.windowController,
    required this.args,
  });

  final WindowController windowController;
  final Map<dynamic, dynamic>? args;

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: 'Flutter Tips',
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
      themeMode: ThemeMode.system,
      home: MacosWindow(
        backgroundColor: Colors.transparent,
        child: MacosScaffold(
          children: [
            ContentArea(
              builder: (context, scrollController) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'About Flutter Tips',
                        style: MacosTheme.of(context).typography.largeTitle,
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'This is a starter application generated by mason_cli.',
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
