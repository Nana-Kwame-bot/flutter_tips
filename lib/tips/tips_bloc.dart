import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_tips/bootstrap.dart';
import 'package:flutter_tips/home/widgets/load_sccuess.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tips_and_tricks_api/tips_and_tricks_api.dart';
import 'package:tips_repository/tips_repository.dart';
import 'package:tuple/tuple.dart';

part 'tips_event.dart';
part 'tips_state.dart';
part 'tips_bloc.freezed.dart';

class TipsBloc extends Bloc<TipsEvent, TipsState> {
  TipsBloc({required TipsRepository tipsRepository})
      : _tipsRepository = tipsRepository,
        super(const _Initial()) {
    on<_DataRequested>(_onDataRequested);
    on<_LoadMoreRequested>(_onLoadMoreRequested);
  }

  final TipsRepository _tipsRepository;

  FutureOr<void> _onDataRequested(
    _DataRequested event,
    Emitter<TipsState> emit,
  ) async {
    emit(const _LoadInProgress());
    try {
      final response = await _tipsRepository.responseData();
      final tips = _tipsRepository.getTips(data: response.data as String);
      emit(_LoadSuccess(tips: tips, currentItemCount: 9));
      logger.i(tips.first);
    } on DioException catch (e) {
      emit(_LoadFailure(e.errorMessage));
      logger.e(e.errorMessage);
    } catch (_) {
      emit(const _LoadFailure());
    }
  }

  FutureOr<void> _onLoadMoreRequested(
    _LoadMoreRequested event,
    Emitter<TipsState> emit,
  ) {
    Tuple2<List<TipUrl>, int> stateItems = state.whenOrNull(
      loadSuccess: (
        tips,
        currentItemCount,
      ) {
        return Tuple2(tips, currentItemCount);
      },
    )!;

    var tips = stateItems.item1;
    var totalItemCount = tips.length;
    var currentItemCount = stateItems.item2;

    if (currentItemCount < totalItemCount) {
      if (totalItemCount - currentItemCount <= 9) {
        emit(
          _LoadSuccess(
            currentItemCount: (totalItemCount - currentItemCount),
            tips: tips,
          ),
        );
        return null;
      }
      currentItemCount = currentItemCount + 9;
      emit(_LoadSuccess(tips: tips, currentItemCount: currentItemCount));
    }
  }
}
