import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masiha_admin/repositories/doctor_request_repository.dart';
import 'doctor_requests_event.dart';
import 'doctor_requests_state.dart';

class DoctorRequestsBloc
    extends Bloc<DoctorRequestsEvent, DoctorRequestsState> {
  final DoctorRequestsRepository repository;

  DoctorRequestsBloc(this.repository) : super(DoctorRequestsInitialState()) {
    on<FetchDoctorRequestsEvent>(_onFetchDoctorRequests);
    on<UpdateRequestStatusEvent>(_onUpdateRequestStatus);
  }

  Future<void> _onFetchDoctorRequests(
      FetchDoctorRequestsEvent event, Emitter<DoctorRequestsState> emit) async {
    emit(DoctorRequestsLoadingState());
    try {
      final requests = await repository.fetchDoctorRequests(event.status);
      emit(DoctorRequestsLoadedState(requests));
    } catch (e) {
      emit(DoctorRequestsErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateRequestStatus(
      UpdateRequestStatusEvent event, Emitter<DoctorRequestsState> emit) async {
    try {
      await repository.updateRequestStatus(event.requestId, event.newStatus);
      // Optionally, re-fetch the requests to update the UI
      add(FetchDoctorRequestsEvent(event.newStatus));
    } catch (e) {
      emit(DoctorRequestsErrorState(e.toString()));
    }
  }
}
