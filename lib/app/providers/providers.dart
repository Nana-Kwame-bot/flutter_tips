import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
class PageIndex extends _$PageIndex {
  @override
  int build() {
    return 0;
  }

  @override
  set state(int index) => super.state = index;
}
