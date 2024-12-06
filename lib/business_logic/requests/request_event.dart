import 'package:equatable/equatable.dart';

abstract class RequestEvent extends Equatable {
  const RequestEvent();

  @override
  List<Object> get props => [];
}

class FetchRequests extends RequestEvent {}

class ApproveRequest extends RequestEvent {
  final String requestId;

  const ApproveRequest(this.requestId);

  @override
  List<Object> get props => [requestId];
}

class DeclineRequest extends RequestEvent {
  final String requestId;

  const DeclineRequest(this.requestId);

  @override
  List<Object> get props => [requestId];
}
