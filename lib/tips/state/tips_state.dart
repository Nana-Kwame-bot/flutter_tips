import 'package:equatable/equatable.dart';
import 'package:tips_repository/tips_repository.dart';

class TipsState extends Equatable {
  final List<Tip> tips;
  final int currentItemCount;

  const TipsState({
    required this.tips,
    required this.currentItemCount,
  });

  TipsState copyWith({
    List<Tip>? tips,
    int? currentItemCount,
  }) {
    return TipsState(
      tips: tips ?? this.tips,
      currentItemCount: currentItemCount ?? this.currentItemCount,
    );
  }

  @override
  List<Object> get props => [tips, currentItemCount];
}
