import 'package:masiha_admin/model/doctor_details_model.dart';

abstract class DoctorRequestsEvent {}

class FetchDoctorRequestsEvent extends DoctorRequestsEvent {
  final RequestStatus status;
  FetchDoctorRequestsEvent(this.status);
}

class UpdateRequestStatusEvent extends DoctorRequestsEvent {
  final String requestId;
  final RequestStatus newStatus;
  UpdateRequestStatusEvent(this.requestId, this.newStatus);
}
