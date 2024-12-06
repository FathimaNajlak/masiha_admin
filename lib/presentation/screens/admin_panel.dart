import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:masiha_admin/model/doctor_details_model.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int _selectedIndex = 0;
  List<DoctorDetailsModel> _requests = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctorRequests();
  }

  Future<void> _fetchDoctorRequests() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('doctorRequests').get();

      setState(() {
        _requests = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return DoctorDetailsModel.fromJson(data)..requestId = doc.id;
        }).toList();
      });
    } catch (e) {
      print('Error fetching doctor requests: $e');
    }
  }

  Future<void> _updateRequestStatus(
      String requestId, RequestStatus status) async {
    try {
      await FirebaseFirestore.instance
          .collection('doctorRequests')
          .doc(requestId)
          .update({
        'requestStatus': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Refresh the list
      _fetchDoctorRequests();
    } catch (e) {
      print('Error updating request status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredRequests = _requests.where((request) {
      switch (_selectedIndex) {
        case 0:
          return request.requestStatus == RequestStatus.pending;
        case 1:
          return request.requestStatus == RequestStatus.approved;
        case 2:
          return request.requestStatus == RequestStatus.rejected;
        default:
          return false;
      }
    }).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB2EBF2),
        elevation: 0,
        centerTitle: true,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushNamed(context, '/registration'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/logo2nobg.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        title: const Text('Admin Panel'),
        toolbarHeight: 80,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            color: const Color(0xFFE0F7FA),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor:
                        _selectedIndex == 0 ? Colors.blue : Colors.black,
                  ),
                  child: const Text('Pending Requests'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor:
                        _selectedIndex == 1 ? Colors.blue : Colors.black,
                  ),
                  child: const Text('Accepted Requests'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor:
                        _selectedIndex == 2 ? Colors.blue : Colors.black,
                  ),
                  child: const Text('Rejected Requests'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRequests.length,
              itemBuilder: (context, index) {
                final request = filteredRequests[index];
                return DoctorRequestCard(
                  request: request,
                  onApprove: () => _updateRequestStatus(
                      request.requestId!, RequestStatus.approved),
                  onDecline: () => _updateRequestStatus(
                      request.requestId!, RequestStatus.rejected),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorRequestCard extends StatelessWidget {
  final DoctorDetailsModel request;
  final VoidCallback? onApprove;
  final VoidCallback? onDecline;

  const DoctorRequestCard({
    super.key,
    required this.request,
    this.onApprove,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(request.fullName ?? 'Unknown Doctor'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hospital: ${request.hospitalName ?? 'N/A'}'),
            Text('Experience: ${request.yearOfExperience ?? 0} years'),
            Text('Specialty: ${request.specialization ?? 'N/A'}'),
          ],
        ),
        trailing: onApprove != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: onApprove,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: onDecline,
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
