import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tips/tips/tips_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
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
              )
            ],
          ),
          children: [
            ContentArea(
              builder: (context, scrollController) {
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      context.read<TipsBloc>().add(
                            const TipsEvent.dataRequested(),
                          );
                    },
                    child: const Text('Home'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
