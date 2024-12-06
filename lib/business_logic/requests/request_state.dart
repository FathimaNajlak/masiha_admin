import 'package:equatable/equatable.dart';
import 'package:masiha_admin/model/request.dart';

class RequestState extends Equatable {
  final List<Request> pendingRequests;
  final List<Request> approvedRequests;
  final List<Request> declinedRequests;

  const RequestState({
    required this.pendingRequests,
    required this.approvedRequests,
    required this.declinedRequests,
  });

  @override
  List<Object?> get props =>
      [pendingRequests, approvedRequests, declinedRequests];
}
