import 'package:riverpod_annotation/riverpod_annotation.dart';

/// @riverpod
/// class PageIndex extends _$PageIndex with AutoDisposeStateControllerMixin<int> {
///   @override
///   int build() {
///     return 0;
///   }
/// }
///
/// ref.watch(pageIndexProvider.notifier).state = 1;
/// ref.watch(pageIndexProvider.notifier).update((state) => state + 1);
///
mixin AutoDisposeStateControllerMixin<T> on AutoDisposeNotifier<T> {
  @override
  set state(T value) => super.state = value;

  T update(T Function(T state) cb) => state = cb(state);
}

mixin StateControllerMixin<T> on Notifier<T> {
  @override
  set state(T value) => super.state = value;

  T update(T Function(T state) cb) => state = cb(state);
}
