// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:masiha_admin/model/doctor_details_model.dart'; // Optional: for better image loading

// class AdminPanel extends StatefulWidget {
//   const AdminPanel({super.key});

//   @override
//   _AdminPanelState createState() => _AdminPanelState();
// }

// class _AdminPanelState extends State<AdminPanel> {
//   int _selectedIndex = 0;
//   List<DoctorDetailsModel> _requests = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchDoctorRequests();
//   }

//   Future<void> _fetchDoctorRequests() async {
//     try {
//       final querySnapshot =
//           await FirebaseFirestore.instance.collection('doctorRequests').get();

//       setState(() {
//         _requests = querySnapshot.docs.map((doc) {
//           final data = doc.data();
//           return DoctorDetailsModel.fromJson(data)..requestId = doc.id;
//         }).toList();
//       });
//     } catch (e) {
//       print('Error fetching doctor requests: $e');
//     }
//   }

//   Future<void> _updateRequestStatus(
//       String requestId, RequestStatus status) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('doctorRequests')
//           .doc(requestId)
//           .update({
//         'requestStatus': status.toString().split('.').last,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       // Refresh the list
//       _fetchDoctorRequests();
//     } catch (e) {
//       print('Error updating request status: $e');
//     }
//   }

//   void _showDoctorDetailsDialog(DoctorDetailsModel request) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(request.fullName ?? 'Doctor Details'),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Profile Image
//                 if (request.imagePath != null)
//                   Center(
//                     child: CircleAvatar(
//                       radius: 60,
//                       backgroundImage:
//                           CachedNetworkImageProvider(request.imagePath!),
//                     ),
//                   ),

//                 // Personal Details
//                 _buildSectionHeader('Personal Information'),
//                 _buildDetailRow('Full Name', request.fullName),
//                 _buildDetailRow('Email', request.email),
//                 _buildDetailRow('Gender', request.gender),
//                 _buildDetailRow('Age', request.age?.toString()),
//                 _buildDetailRow(
//                     'Date of Birth',
//                     request.dateOfBirth != null
//                         ? request.dateOfBirth!
//                             .toLocal()
//                             .toString()
//                             .split(' ')[0]
//                         : null),

//                 // Professional Details
//                 _buildSectionHeader('Professional Information'),
//                 _buildDetailRow('Hospital', request.hospitalName),
//                 _buildDetailRow('Specialization', request.specialty),
//                 _buildDetailRow('Years of Experience',
//                     request.yearOfExperience?.toString()),

//                 // Education Details
//                 _buildSectionHeader('Education'),
//                 if (request.educations != null &&
//                     request.educations!.isNotEmpty)
//                   ...request.educations!.map((edu) => Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildDetailRow('Degree', edu.degree),
//                           _buildDetailRow('Institution', edu.institution),
//                           _buildDetailRow('Year of Completion',
//                               edu.yearOfCompletion?.toString()),
//                           if (edu.certificatePath != null)
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 8.0),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   // TODO: Implement certificate view/download
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                       content: Text(
//                                           'Certificate view not implemented'),
//                                     ),
//                                   );
//                                 },
//                                 child: const Text(
//                                   'View Certificate',
//                                   style: TextStyle(
//                                     color: Colors.blue,
//                                     decoration: TextDecoration.underline,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           const Divider(),
//                         ],
//                       ))
//                 else
//                   const Text('No education details available'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Close'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           decoration: TextDecoration.underline,
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String? value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$label: ',
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Expanded(
//             child: Text(value ?? 'N/A'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filteredRequests = _requests.where((request) {
//       return request.requestStatus ==
//           [
//             RequestStatus.pending,
//             RequestStatus.approved,
//             RequestStatus.rejected
//           ][_selectedIndex];
//     }).toList();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFB2EBF2),
//         elevation: 0,
//         centerTitle: true,
//         leading: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () => Navigator.pushNamed(context, '/registration'),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.asset(
//                   'assets/images/logo2nobg.png',
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         title: const Text('Admin Panel'),
//         toolbarHeight: 80,
//       ),
//       body: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 200,
//             color: const Color(0xFFE0F7FA),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextButton(
//                   onPressed: () => setState(() => _selectedIndex = 0),
//                   style: TextButton.styleFrom(
//                     foregroundColor:
//                         _selectedIndex == 0 ? Colors.blue : Colors.black,
//                   ),
//                   child: const Text('Pending Requests'),
//                 ),
//                 TextButton(
//                   onPressed: () => setState(() => _selectedIndex = 1),
//                   style: TextButton.styleFrom(
//                     foregroundColor:
//                         _selectedIndex == 1 ? Colors.blue : Colors.black,
//                   ),
//                   child: const Text('Accepted Requests'),
//                 ),
//                 TextButton(
//                   onPressed: () => setState(() => _selectedIndex = 2),
//                   style: TextButton.styleFrom(
//                     foregroundColor:
//                         _selectedIndex == 2 ? Colors.blue : Colors.black,
//                   ),
//                   child: const Text('Rejected Requests'),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredRequests.length,
//               itemBuilder: (context, index) {
//                 final request = filteredRequests[index];
//                 return DoctorRequestCard(
//                   request: request,
//                   onTap: () => _showDoctorDetailsDialog(request),
//                   onApprove: () => _updateRequestStatus(
//                       request.requestId!, RequestStatus.approved),
//                   onDecline: () => _updateRequestStatus(
//                       request.requestId!, RequestStatus.rejected),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DoctorRequestCard extends StatelessWidget {
//   final DoctorDetailsModel request;
//   final VoidCallback? onApprove;
//   final VoidCallback? onDecline;
//   final VoidCallback? onTap;

//   const DoctorRequestCard({
//     super.key,
//     required this.request,
//     this.onApprove,
//     this.onDecline,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         child: ListTile(
//           leading: request.imagePath != null
//               ? CircleAvatar(
//                   backgroundImage:
//                       CachedNetworkImageProvider(request.imagePath!),
//                 )
//               : null,
//           title: Text(request.fullName ?? 'Unknown Doctor'),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Hospital: ${request.hospitalName ?? 'N/A'}'),
//               Text('Experience: ${request.yearOfExperience ?? 0} years'),
//               Text('Specialty: ${request.specialty ?? 'N/A'}'),
//             ],
//           ),
//           trailing: onApprove != null
//               ? Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.check, color: Colors.green),
//                       onPressed: onApprove,
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close, color: Colors.red),
//                       onPressed: onDecline,
//                     ),
//                   ],
//                 )
//               : null,
//         ),
//       ),
//     );
//   }
// }
