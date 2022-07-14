import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tips/tips/providers/providers.dart';
import 'package:flutter_tips/tips/state/tips_state.dart';
import 'package:flutter_tips/tips/widgets/load_sccuess.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:tips_and_tricks_api/tips_and_tricks_api.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      builder: (context) {
        return MacosScaffold(
          toolBar: ToolBar(
            title: const Text('Home'),
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
                return Consumer(
                  builder: (
                    BuildContext context,
                    WidgetRef ref,
                    Widget? child,
                  ) {
                    final tipsState = ref.watch(tipsProvider);

                    _listen(context: context, ref: ref);

                    return tipsState.when(
                      loading: () {
                        return SpinKitSpinningLines(
                          color: MacosTheme.of(context)
                              .tooltipTheme
                              .textStyle!
                              .color!,
                        );
                      },
                      data: (_) {
                        return const LoadSuccess();
                      },
                      error: (_, __) {
                        return Center(
                          child: PushButton(
                            buttonSize: ButtonSize.large,
                            onPressed: () {
                              ref.read(tipsProvider.notifier).getData();
                            },
                            child: const Text('Reload'),
                          ),
                        );
                      },
                    );
                  },
                  // child: Center(
                  //   child: Consumer(
                  //     builder:
                  //         (BuildContext context, WidgetRef ref, Widget? child) {
                  //       return PushButton(
                  //         buttonSize: ButtonSize.large,
                  //         onPressed: () {
                  //           // Navigator.of(context).push(
                  //           //   Details.route(),
                  //           // );
                  //           ref.read(tipsProvider.notifier).getData();
                  //         },
                  //         child: const Text('Get data'),
                  //       );
                  //     },
                  //   ),
                  // ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _listen({required WidgetRef ref, required BuildContext context}) {
    ref.listen<AsyncValue<TipsState>>(
      tipsProvider,
      (_, next) {
        next.whenOrNull<void>(
          error: (object, stackTrace) {
            final dioException = object as DioException;
            showMacosAlertDialog(
              context: context,
              builder: (context) {
                return MacosAlertDialog(
                  appIcon: const FlutterLogo(
                    size: 56,
                  ),
                  title: Text(
                    'Failed to load data',
                    style: MacosTheme.of(context).typography.headline,
                  ),
                  message: Text(
                    dioException.errorMessage,
                    textAlign: TextAlign.center,
                    style: MacosTheme.of(context).typography.headline,
                  ),
                  primaryButton: PushButton(
                    buttonSize: ButtonSize.large,
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
