// lib/data/repositories/doctor_requests_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:masiha_admin/model/doctor_details_model.dart';

class DoctorRequestsRepository {
  final FirebaseFirestore _firestore;

  DoctorRequestsRepository(this._firestore);

  Future<List<DoctorDetailsModel>> fetchDoctorRequests(
      RequestStatus status) async {
    try {
      final querySnapshot = await _firestore
          .collection('doctorRequests')
          .where('requestStatus', isEqualTo: status.toString().split('.').last)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return DoctorDetailsModel.fromJson(data)..requestId = doc.id;
      }).toList();
    } catch (e) {
      print('Error fetching doctor requests: $e');
      return [];
    }
  }

  Future<void> updateRequestStatus(
      String requestId, RequestStatus status) async {
    try {
      await _firestore.collection('doctorRequests').doc(requestId).update({
        'requestStatus': status.toString().split('.').last,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating request status: $e');
    }
  }
}
