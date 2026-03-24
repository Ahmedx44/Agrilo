import 'package:agrilo/core/services/toast_service.dart';
import 'package:agrilo/features/dashboard/cubit/dashboard_state.dart';
import 'package:agrilo/features/dashboard/repository/dashboard_repository.dart';
import 'package:bloc/bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({required DashboardRepository repository})
      : _repository = repository,
        super(const DashboardState());

  final DashboardRepository _repository;

  Future<void> fetchDashboard() async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final data = await _repository.getDashboardData();

      emit(state.copyWith(
        status: DashboardStatus.success,
        totalTests: data['totalTests'] as int? ?? 0,
        avgMoisture: data['avgMoisture'] as int? ?? 0,
        avgPH: (data['avgPH'] as num?)?.toDouble() ?? 0.0,
        avgNutrients: (data['avgNutrients'] as Map<String, dynamic>?) ?? {},
        latestScan: data['latestScan'] as Map<String, dynamic>?,
        history: data['history'] as List<dynamic>? ?? [],
      ));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      ToastService.showError(msg);
      emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: msg,
      ));
    }
  }

  // Keep old name as alias for backwards compat
  Future<void> loadDashboard() => fetchDashboard();
}
