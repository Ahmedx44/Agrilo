import 'package:agrilo/features/soil/cubit/soil_history_state.dart';
import 'package:agrilo/features/soil/repository/soil_repository.dart';
import 'package:bloc/bloc.dart';

class SoilHistoryCubit extends Cubit<SoilHistoryState> {
  SoilHistoryCubit({required SoilRepository repository})
      : _repository = repository,
        super(const SoilHistoryState());

  final SoilRepository _repository;

  Future<void> loadHistory() async {
    emit(state.copyWith(status: SoilHistoryStatus.loading));
    try {
      final history = await _repository.getHistory();
      emit(state.copyWith(
        status: SoilHistoryStatus.success,
        history: history,
      ));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      emit(state.copyWith(
        status: SoilHistoryStatus.failure,
        errorMessage: msg,
      ));
    }
  }
}
