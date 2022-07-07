import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tips/tips/tips_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

class LoadMore extends StatelessWidget {
  const LoadMore({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: PushButton(
            padding: const EdgeInsets.all(12.0),
            buttonSize: ButtonSize.large,
            child: const Text("Load more"),
            onPressed: () async {
              context.read<TipsBloc>().add(
                    const TipsEvent.loadMoreRequested(),
                  );
              await Future.delayed(const Duration(milliseconds: 50), () {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  onPressed.call();
                });
              });
            },
          ),
        ),
      ),
    );
  }
}
