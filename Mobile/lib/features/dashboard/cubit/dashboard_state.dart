import 'package:equatable/equatable.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.totalTests = 0,
    this.avgMoisture = 0,
    this.avgPH = 0.0,
    this.avgNutrients = const {},
    this.latestScan,
    this.history = const [],
    this.errorMessage,
  });

  final DashboardStatus status;
  final int totalTests;
  final int avgMoisture;
  final double avgPH;
  final Map<String, dynamic> avgNutrients;
  final Map<String, dynamic>? latestScan;
  final List<dynamic> history;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        status,
        totalTests,
        avgMoisture,
        avgPH,
        avgNutrients,
        latestScan,
        history,
        errorMessage,
      ];

  DashboardState copyWith({
    DashboardStatus? status,
    int? totalTests,
    int? avgMoisture,
    double? avgPH,
    Map<String, dynamic>? avgNutrients,
    Map<String, dynamic>? latestScan,
    List<dynamic>? history,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      totalTests: totalTests ?? this.totalTests,
      avgMoisture: avgMoisture ?? this.avgMoisture,
      avgPH: avgPH ?? this.avgPH,
      avgNutrients: avgNutrients ?? this.avgNutrients,
      latestScan: latestScan ?? this.latestScan,
      history: history ?? this.history,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
