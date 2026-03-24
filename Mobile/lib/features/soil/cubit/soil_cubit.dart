import 'dart:io';

import 'package:agrilo/core/services/toast_service.dart';
import 'package:agrilo/features/soil/cubit/soil_state.dart';
import 'package:agrilo/features/soil/repository/soil_repository.dart';
import 'package:bloc/bloc.dart';

class SoilCubit extends Cubit<SoilState> {
  SoilCubit({required SoilRepository repository})
      : _repository = repository,
        super(const SoilState());

  final SoilRepository _repository;

  Future<void> analyzeSoil(File imageFile) async {
    emit(state.copyWith(status: SoilStatus.loading));
    try {
      await _repository.analyzeSoil(imageFile);
      
      ToastService.showSuccess('Soil successfully analyzed');
      emit(state.copyWith(status: SoilStatus.success));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      ToastService.showError(msg);
      emit(state.copyWith(
        status: SoilStatus.failure,
        errorMessage: msg,
      ));
    }
  }
}
