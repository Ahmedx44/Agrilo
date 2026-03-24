import 'package:equatable/equatable.dart';

enum SoilStatus { initial, loading, success, failure }

class SoilState extends Equatable {
  const SoilState({
    this.status = SoilStatus.initial,
    this.errorMessage,
  });

  final SoilStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];

  SoilState copyWith({
    SoilStatus? status,
    String? errorMessage,
  }) {
    return SoilState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
