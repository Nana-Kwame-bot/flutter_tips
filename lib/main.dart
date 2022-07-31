import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tips/app/views/about_window.dart';
import 'package:flutter_tips/app/views/app.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger(
  // Customize the printer
  printer: PrettyPrinter(
    methodCount: 0,
  ),
);

void main(List<String> args) async {
  if (args.firstOrNull == 'multi_window') {
    final windowId = int.parse(args[1]);
    final arguments = args[2].isEmpty
        ? const <String, dynamic>{}
        : jsonDecode(args[2]) as Map<String, dynamic>;
    runApp(
      AboutWindow(
        windowController: WindowController.fromWindowId(windowId),
        args: arguments,
      ),
    );
  } else {
    EquatableConfig.stringify = true;
    runApp(const App());
  }
}
