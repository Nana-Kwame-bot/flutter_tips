import 'package:flutter/material.dart';
import 'package:flutter_tips/provider_observer/provider_observer.dart';
import 'package:flutter_tips/routes/routes.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';

class App extends StatelessWidget {
  const App({super.key});

  static const String _title = "Flutter Tips";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      observers: [Logger()],
      child: MacosApp.router(
        title: _title,
        theme: MacosThemeData.light(),
        darkTheme: MacosThemeData.dark(),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routeInformationParser: goRouter.routeInformationParser,
        routerDelegate: goRouter.routerDelegate,
        routeInformationProvider: goRouter.routeInformationProvider,
      ),
    );
  }
}
