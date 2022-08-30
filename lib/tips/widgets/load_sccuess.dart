import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tips/tip_details/view/tip_details.dart';
import 'package:flutter_tips/tip_options/views/show_options.dart';
import 'package:flutter_tips/tip_options/views/tip_option_button.dart';
import 'package:flutter_tips/tips/notifiers/tips_search_notifier.dart';
import 'package:flutter_tips/tips/providers/providers.dart';
import 'package:flutter_tips/tips/widgets/load_more.dart';
import 'package:flutter_tips/tips/widgets/tips_search_field.dart';
import 'package:go_router/go_router.dart';
import 'package:macos_ui/macos_ui.dart';

class LoadSuccess extends ConsumerStatefulWidget {
  const LoadSuccess({super.key});

  @override
  ConsumerState<LoadSuccess> createState() => _LoadSuccessState();
}

class _LoadSuccessState extends ConsumerState<LoadSuccess> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final currentTips = ref.watch(currentTipsProvider);
            return NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: MacosTheme.of(context).canvasColor,
                    pinned: true,
                    title: const TipsSearchField(),
                  ),
                ];
              },
              body: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.5,
                        mainAxisSpacing: 30,
                        crossAxisSpacing: 30,
                        crossAxisCount: _getCrossAxisCount(
                          constraints.maxWidth ~/ 400,
                        ),
                      ),
                      delegate: SliverChildBuilderDelegate(
                        childCount: currentTips.length,
                        (context, index) {
                          return ShowOptions(
                            index: index,
                            child: GestureDetector(
                              onDoubleTap: () {
                                ref.read(tipsSearchProvider.notifier).selectTip(
                                      selectedTipTile: currentTips[index].title,
                                    );
                                context.goNamed(TipDetails.name);
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                fit: StackFit.passthrough,
                                alignment: Alignment.center,
                                children: [
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: MacosTheme.of(context)
                                            .tooltipTheme
                                            .textStyle!
                                            .color!,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Hero(
                                        tag: currentTips[index].imageUrl,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          memCacheWidth:
                                              constraints.maxWidth.toInt(),
                                          imageUrl: currentTips[index].imageUrl,
                                          placeholder: (context, url) {
                                            return SpinKitSpinningLines(
                                              size: 35,
                                              color: MacosTheme.of(context)
                                                  .tooltipTheme
                                                  .textStyle!
                                                  .color!,
                                            );
                                          },
                                          errorWidget: (context, url, error) {
                                            return DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: MacosTheme.of(context)
                                                    .canvasColor,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                    CupertinoIcons
                                                        .exclamationmark_circle_fill,
                                                    color: Colors.redAccent,
                                                  ),
                                                  Text(
                                                    "Failed to get image",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  TipOptionButton(index: index),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  LoadMore(
                    onPressed: () {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent - 80,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn,
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

int _getCrossAxisCount(num value) {
  if (value < 1 || value.isInfinite || value.isNaN) {
    return 1;
  }
  return value.toInt();
}
