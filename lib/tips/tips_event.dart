part of 'tips_bloc.dart';

@freezed
class TipsEvent with _$TipsEvent {
  const factory TipsEvent.dataRequested() = _DataRequested;
}
