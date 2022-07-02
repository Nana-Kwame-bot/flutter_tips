import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:tips_and_tricks_api/tips_and_tricks_api.dart';
import 'package:tips_repository/tips_repository.dart';

part 'tips_event.dart';
part 'tips_state.dart';
part 'tips_bloc.freezed.dart';

final Logger logger = Logger(
  // Customize the printer
  printer: PrettyPrinter(
    methodCount: 0,
    printTime: false,
  ),
);

class TipsBloc extends Bloc<TipsEvent, TipsState> {
  TipsBloc({required TipsRepository tipsRepository})
      : _tipsRepository = tipsRepository,
        super(const _Initial()) {
    on<_DataRequested>(_onDataRequested, transformer: droppable());
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
      emit(_LoadSuccess(tips: tips));
      logger.i(tips.first);
    } on DioException catch (e) {
      emit(_LoadFailure(e.errorMessage));
      logger.e(e.errorMessage);
    } catch (_) {
      emit(const _LoadFailure());
    }
  }
}
