import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tips/tips/providers/providers.dart';
import 'package:macos_ui/macos_ui.dart';

class ImageTab extends StatelessWidget {
  const ImageTab({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: MacosTheme.of(context).tooltipTheme.textStyle!.color!,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Consumer(
              builder: (context, ref, child) {
                final tip = ref.watch(tipsSearchProvider);
                return Hero(
                  tag: tip.imageUrl,
                  child: CachedNetworkImage(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    fit: BoxFit.fill,
                    imageUrl: tip.imageUrl,
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
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: MacosTheme.of(context).canvasColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              CupertinoIcons.exclamationmark_circle_fill,
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
        );
      },
    );
  }
}
