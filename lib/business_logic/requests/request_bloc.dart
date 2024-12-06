import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masiha_admin/business_logic/requests/request_event.dart';
import 'package:masiha_admin/business_logic/requests/request_state.dart';
import 'package:masiha_admin/model/request.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RequestBloc()
      : super(const RequestState(
            pendingRequests: [], approvedRequests: [], declinedRequests: [])) {
    on<FetchRequests>(_onFetchRequests);
    on<ApproveRequest>(_onApproveRequest);
    on<DeclineRequest>(_onDeclineRequest);
  }

  Future<void> _onFetchRequests(
      FetchRequests event, Emitter<RequestState> emit) async {
    final pendingSnapshot = await _firestore
        .collection('requests')
        .where('isApproved', isEqualTo: false)
        .get();
    final approvedSnapshot = await _firestore
        .collection('requests')
        .where('isApproved', isEqualTo: true)
        .get();
    final declinedSnapshot = await _firestore
        .collection('requests')
        .where('isApproved', isEqualTo: false)
        .where('isDeclined', isEqualTo: true)
        .get();

    final pendingRequests = pendingSnapshot.docs
        .map((doc) => Request(
              id: doc.id,
              name: doc['name'],
              category: doc['category'],
              isApproved: doc['isApproved'],
            ))
        .toList();

    final approvedRequests = approvedSnapshot.docs
        .map((doc) => Request(
              id: doc.id,
              name: doc['name'],
              category: doc['category'],
              isApproved: doc['isApproved'],
            ))
        .toList();

    final declinedRequests = declinedSnapshot.docs
        .map((doc) => Request(
              id: doc.id,
              name: doc['name'],
              category: doc['category'],
              isApproved: doc['isApproved'],
            ))
        .toList();

    emit(RequestState(
      pendingRequests: pendingRequests,
      approvedRequests: approvedRequests,
      declinedRequests: declinedRequests,
    ));
  }

  Future<void> _onApproveRequest(
      ApproveRequest event, Emitter<RequestState> emit) async {
    await _firestore
        .collection('requests')
        .doc(event.requestId)
        .update({'isApproved': true});
    add(FetchRequests());
  }

  Future<void> _onDeclineRequest(
      DeclineRequest event, Emitter<RequestState> emit) async {
    await _firestore
        .collection('requests')
        .doc(event.requestId)
        .update({'isApproved': false, 'isDeclined': true});
    add(FetchRequests());
  }
}
