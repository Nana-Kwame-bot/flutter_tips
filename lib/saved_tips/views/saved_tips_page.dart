import 'dart:io';
import "package:flutter/cupertino.dart";
import 'package:flutter/material.dart';
import 'package:flutter_tips/saved_tips/notifiers/saved_tips_notifier.dart';
import 'package:flutter_tips/saved_tips/widgets/open_option.dart';
import 'package:flutter_tips/saved_tips/widgets/saved_tip_open_option_button.dart';
import 'package:flutter_tips/tip_details/views/tip_details.dart';
import 'package:flutter_tips/tips/notifiers/tips_search_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:macos_ui/macos_ui.dart";

class SavedTipsPage extends ConsumerStatefulWidget {
  const SavedTipsPage({super.key});

  @override
  ConsumerState<SavedTipsPage> createState() => _SavedTipsPageState();
}

class _SavedTipsPageState extends ConsumerState<SavedTipsPage> {
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
    return CupertinoTabView(
      builder: (context) {
        return MacosScaffold(
          toolBar: ToolBar(
            title: const Text("Saved Tips"),
            actions: [
              ToolBarIconButton(
                label: "Toggle Sidebar",
                icon: const MacosIcon(CupertinoIcons.sidebar_left),
                showLabel: false,
                tooltipMessage: "Toggle Sidebar",
                onPressed: () {
                  MacosWindowScope.of(context).toggleSidebar();
                },
              ),
            ],
          ),
          children: [
            ContentArea(
              builder: (context, scrollController) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final savedTips =
                        ref.watch(savedTipsNotifierProvider).savedTips;
                    return NestedScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            backgroundColor: MacosTheme.of(context).canvasColor,
                            pinned: true,
                            // title: const TipsSearchField(),
                          ),
                        ];
                      },
                      body: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.all(16.0),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1.5,
                                mainAxisSpacing: 30,
                                crossAxisSpacing: 30,
                                crossAxisCount: _getCrossAxisCount(
                                  constraints.maxWidth ~/ 400,
                                ),
                              ),
                              delegate: SliverChildBuilderDelegate(
                                childCount: savedTips.length,
                                (context, index) {
                                  return SavedTipOptions(
                                    index: index,
                                    child: GestureDetector(
                                      onDoubleTap: () {
                                        ref
                                            .read(
                                              tipsSearchNotifierProvider
                                                  .notifier,
                                            )
                                            .selectTip(
                                              selectedTipTile:
                                                  savedTips[index].title,
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
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: MacosTheme.of(context)
                                                    .tooltipTheme
                                                    .textStyle!
                                                    .color!,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Hero(
                                                tag: savedTips[index].imagePath,
                                                child: Image.file(
                                                  File(
                                                    savedTips[index].imagePath,
                                                  ),
                                                  fit: BoxFit.fill,
                                                  cacheWidth: constraints
                                                      .maxWidth
                                                      .toInt(),
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return DecoratedBox(
                                                      decoration: BoxDecoration(
                                                        color: MacosTheme.of(
                                                          context,
                                                        ).canvasColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(
                                                            CupertinoIcons
                                                                .exclamationmark_circle_fill,
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                          Text(
                                                            "Failed to get image",
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          SavedTipsOptionsButton(
                                            index: index,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          // LoadMore(
                          //   onPressed: () {
                          //     if (_scrollController.hasClients) {
                          //       _scrollController.animateTo(
                          //         _scrollController.position.maxScrollExtent - 80,
                          //         duration: const Duration(milliseconds: 500),
                          //         curve: Curves.fastOutSlowIn,
                          //       );
                          //     }
                          //   },
                          // ),
                        ],
                      ),
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

  int _getCrossAxisCount(num value) {
    if (value < 1 || value.isInfinite || value.isNaN) {
      return 1;
    }
    return value.toInt();
  }
}
