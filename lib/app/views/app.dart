import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/app/views/main_view.dart';
import 'package:flutter_tips/provider_observer/provider_observer.dart';
import 'package:macos_ui/macos_ui.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      observers: [Logger()],
      child: MacosApp(
        title: 'Flutter Tips',
        theme: MacosThemeData.light(),
        darkTheme: MacosThemeData.dark(),
        themeMode: ThemeMode.system,
        home: const MainView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
