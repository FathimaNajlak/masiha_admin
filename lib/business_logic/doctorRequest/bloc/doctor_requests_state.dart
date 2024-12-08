import 'package:masiha_admin/model/doctor_details_model.dart';

abstract class DoctorRequestsState {}

class DoctorRequestsInitialState extends DoctorRequestsState {}

class DoctorRequestsLoadingState extends DoctorRequestsState {}

class DoctorRequestsLoadedState extends DoctorRequestsState {
  final List<DoctorDetailsModel> requests;
  DoctorRequestsLoadedState(this.requests);
}

class DoctorRequestsErrorState extends DoctorRequestsState {
  final String error;
  DoctorRequestsErrorState(this.error);
}
