import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tips/app/bloc_observer/app_blocobserver.dart';
import 'package:flutter_tips/app/views/about_window.dart';
import 'package:flutter_tips/app/views/app.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main(List<String> args) async {
  HydratedBlocOverrides.runZoned(
    () {
      if (args.firstOrNull == 'multi_window') {
        final windowId = int.parse(args[1]);
        final arguments = args[2].isEmpty
            ? const {}
            : jsonDecode(args[2]) as Map<String, dynamic>;
        runApp(
          AboutWindow(
            windowController: WindowController.fromWindowId(windowId),
            args: arguments,
          ),
        );
      } else {
        runApp(const App());
      }
    },
    createStorage: () async {
      WidgetsFlutterBinding.ensureInitialized();

      return HydratedStorage.build(
        storageDirectory: await getApplicationDocumentsDirectory(),
      );
    },
    blocObserver: AppBlocObserver(),
  );
}
