import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tips/tip_details/notifiers/code_notifier.dart';
import 'package:highlight/languages/dart.dart';
import 'package:macos_ui/macos_ui.dart';

class CodeTab extends StatelessWidget {
  const CodeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: MacosTheme.of(context).canvasColor,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: MacosTheme.of(context).canvasColor,
          child: Consumer(
            builder: (context, ref, child) {
              final codeState = ref.watch(codeProvider);

              return codeState.when(
                loaded: (data) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        height: constraints.maxHeight,
                        child: SingleChildScrollView(
                          child: CodeField(
                            controller: CodeController(
                              text: data,
                              theme: draculaTheme,
                              language: dart,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () {
                  return SpinKitSpinningLines(
                    color:
                        MacosTheme.of(context).tooltipTheme.textStyle!.color!,
                  );
                },
                error: (_, __) {
                  return Center(
                    child: PushButton(
                      buttonSize: ButtonSize.large,
                      onPressed: () {
                        ref.refresh(codeProvider);
                      },
                      child: const Text('Reload'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
