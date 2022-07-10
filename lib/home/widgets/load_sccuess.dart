import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tips/home/widgets/load_more.dart';
import 'package:flutter_tips/tips/providers/providers.dart';

class LoadSuccess extends StatefulWidget {
  const LoadSuccess({super.key});

  @override
  State<LoadSuccess> createState() => _LoadSuccessState();
}

class _LoadSuccessState extends State<LoadSuccess> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final tipsState = ref.watch(tipsNotifierProvider);
            return tipsState.maybeWhen(
              loadSuccess: (tips, currentItemCount) {
                return CustomScrollView(
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
                          childCount: currentItemCount,
                          (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(
                                memCacheWidth: constraints.maxWidth.toInt(),
                                imageUrl: tips[index].imageUrl,
                                fit: BoxFit.fill,
                                placeholder: (context, url) {
                                  return const CircularProgressIndicator
                                      .adaptive();
                                },
                                errorWidget: (context, url, error) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
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
                );
              },
              orElse: () {
                return const SizedBox.shrink();
              },
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
