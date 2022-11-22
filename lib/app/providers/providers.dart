import 'package:flutter_tips/mixins/mixins.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
class PageIndex extends _$PageIndex with AutoDisposeNotifierMixin {
  @override
  int build() {
    return 0;
  }

  @override
  set state(int index) => super.state = index;
}
