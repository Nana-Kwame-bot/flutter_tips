import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tips/home/widgets/load_sccuess.dart';
import 'package:flutter_tips/tips/providers/providers.dart';
import 'package:flutter_tips/tips/state/tips_state.dart';
import 'package:macos_ui/macos_ui.dart';

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
                    final tipsState = ref.watch(tipsNotifierProvider);

                    _listen(context: context, ref: ref);

                    return tipsState.when(
                      initial: () {
                        return Center(
                          child: PushButton(
                            buttonSize: ButtonSize.large,
                            onPressed: () {
                              // Navigator.of(context).push(
                              //   Details.route(),
                              // );
                              ref.read(tipsNotifierProvider.notifier).getData();
                            },
                            child: const Text('Get data'),
                          ),
                        );
                      },
                      loadInProgress: () {
                        return SpinKitSpinningLines(
                          color: const Color(0xFF1B1B28).withOpacity(0.6),
                        );
                      },
                      loadSuccess: (_, __) {
                        return const LoadSuccess();
                      },
                      loadFailure: (_) {
                        return Center(
                          child: PushButton(
                            buttonSize: ButtonSize.large,
                            onPressed: () {
                              ref.read(tipsNotifierProvider.notifier).getData();
                            },
                            child: const Text('Reload'),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _listen({required WidgetRef ref, required BuildContext context}) {
    ref.listen<TipsState>(
      tipsNotifierProvider,
      (_, next) {
        next.whenOrNull<void>(
          loadFailure: (errorMessage) {
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
                    errorMessage ?? "Something went wrong",
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
