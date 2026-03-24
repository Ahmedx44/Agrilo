import 'package:equatable/equatable.dart';

enum SoilHistoryStatus { initial, loading, success, failure }

class SoilHistoryState extends Equatable {
  const SoilHistoryState({
    this.status = SoilHistoryStatus.initial,
    this.history = const [],
    this.errorMessage,
  });

  final SoilHistoryStatus status;
  final List<dynamic> history;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, history, errorMessage];

  SoilHistoryState copyWith({
    SoilHistoryStatus? status,
    List<dynamic>? history,
    String? errorMessage,
  }) {
    return SoilHistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
