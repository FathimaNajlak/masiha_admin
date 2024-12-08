import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masiha_admin/business_logic/doctorRequest/bloc/doctor_requests_bloc.dart';
import 'package:masiha_admin/business_logic/doctorRequest/bloc/doctor_requests_event.dart';
import 'package:masiha_admin/business_logic/doctorRequest/bloc/doctor_requests_state.dart';
import 'package:masiha_admin/model/doctor_details_model.dart';
import 'package:masiha_admin/presentation/widgets/doctor_request_card.dart';
import 'package:masiha_admin/utils/consts/colors.dart';

class PendingRequestsPage extends StatefulWidget {
  const PendingRequestsPage({super.key});

  @override
  _PendingRequestsPageState createState() => _PendingRequestsPageState();
}

class _PendingRequestsPageState extends State<PendingRequestsPage> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorRequestsBloc>().add(
          FetchDoctorRequestsEvent(RequestStatus.pending),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorRequestsBloc, DoctorRequestsState>(
      builder: (context, state) {
        if (state is DoctorRequestsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DoctorRequestsErrorState) {
          return Center(child: Text('Error: ${state.error}'));
        }

        if (state is DoctorRequestsLoadedState) {
          return ListView.builder(
            itemCount: state.requests.length,
            itemBuilder: (context, index) {
              final request = state.requests[index];
              return DoctorRequestCard(
                request: request,
                currentStatus: RequestStatus.pending,
                onTap: () => _showDoctorDetailsDialog(request),
                onApprove: () => context.read<DoctorRequestsBloc>().add(
                      UpdateRequestStatusEvent(
                        request.requestId!,
                        RequestStatus.approved,
                      ),
                    ),
                onDecline: () => context.read<DoctorRequestsBloc>().add(
                      UpdateRequestStatusEvent(
                        request.requestId!,
                        RequestStatus.rejected,
                      ),
                    ),
              );
            },
          );
        }

        return const Center(child: Text('No requests found'));
      },
    );
  }

  void _showDoctorDetailsDialog(DoctorDetailsModel request) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Decorative background elements
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ),

                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header with profile image
                        Container(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              if (request.imagePath != null)
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage: CachedNetworkImageProvider(
                                      request.imagePath!,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              Text(
                                request.fullName ?? 'Doctor Details',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (request.specialty != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    request.specialty!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Content sections
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSection(
                                'Personal Information',
                                [
                                  _buildInfoTile(
                                      Icons.email, 'Email', request.email),
                                  _buildInfoTile(
                                      Icons.person, 'Gender', request.gender),
                                  _buildInfoTile(Icons.cake, 'Age',
                                      request.age?.toString()),
                                  _buildInfoTile(
                                    Icons.calendar_today,
                                    'Date of Birth',
                                    request.dateOfBirth != null
                                        ? request.dateOfBirth!
                                            .toLocal()
                                            .toString()
                                            .split(' ')[0]
                                        : null,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              _buildSection(
                                'Professional Information',
                                [
                                  _buildInfoTile(Icons.local_hospital,
                                      'Hospital', request.hospitalName),
                                  _buildInfoTile(
                                      Icons.work,
                                      'Years of Experience',
                                      request.yearOfExperience?.toString()),
                                ],
                              ),
                              const SizedBox(height: 24),
                              _buildSection(
                                'Education',
                                request.educations
                                        ?.map((edu) =>
                                            _buildEducationCard(edu, context))
                                        .toList() ??
                                    [
                                      const Text(
                                          'No education details available')
                                    ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppColors.darkcolor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCard(Education edu, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              edu.degree ?? 'Degree',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              edu.institution ?? 'Institution',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            if (edu.yearOfCompletion != null) ...[
              const SizedBox(height: 4),
              Text(
                'Completed in ${edu.yearOfCompletion}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
            if (edu.certificatePath != null) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.file_download),
                label: const Text('View Certificate'),
                onPressed: () {
                  // TODO: Implement certificate view/download
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Certificate view not implemented')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
