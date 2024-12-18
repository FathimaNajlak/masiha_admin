import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masiha_admin/business_logic/doctorRequest/bloc/doctor_requests_bloc.dart';
import 'package:masiha_admin/business_logic/doctorRequest/bloc/doctor_requests_event.dart';
import 'package:masiha_admin/business_logic/doctorRequest/bloc/doctor_requests_state.dart';
import 'package:masiha_admin/model/doctor_details_model.dart';
import 'package:masiha_admin/presentation/widgets/doctor_request_card.dart';
import 'package:masiha_admin/utils/consts/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptedRequestsPage extends StatefulWidget {
  const AcceptedRequestsPage({super.key});

  @override
  _AcceptedRequestsPageState createState() => _AcceptedRequestsPageState();
}

class _AcceptedRequestsPageState extends State<AcceptedRequestsPage> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorRequestsBloc>().add(
          FetchDoctorRequestsEvent(RequestStatus.approved),
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
                currentStatus: RequestStatus.approved,
                onTap: () => _showDoctorDetailsDialog(request),
                // Optional: You can add functionality to revert or take other actions
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

        return const Center(child: Text('No accepted requests found'));
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
                        Container(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              if (request.imagePath != null)
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: CachedNetworkImageProvider(
                                    request.imagePath!,
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
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSection('Personal Information', [
                                _buildInfoTile(
                                    Icons.email, 'Email', request.email),
                                _buildInfoTile(
                                    Icons.person, 'Gender', request.gender),
                                _buildInfoTile(
                                    Icons.cake, 'Age', request.age?.toString()),
                                _buildInfoTile(
                                  Icons.calendar_today,
                                  'Date of Birth',
                                  request.dateOfBirth
                                      ?.toLocal()
                                      .toString()
                                      .split(' ')[0],
                                ),
                              ]),
                              const SizedBox(height: 24),
                              _buildSection('Professional Information', [
                                _buildInfoTile(Icons.local_hospital, 'Hospital',
                                    request.hospitalName),
                                _buildInfoTile(Icons.work, 'Experience',
                                    '${request.yearOfExperience ?? 'N/A'} years'),
                              ]),
                              const SizedBox(height: 24),
                              _buildSection(
                                'Education',
                                request.educations?.map((edu) {
                                      return _buildEducationCard(edu, context);
                                    }).toList() ??
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
                onPressed: () => viewCertificate(context, edu.certificatePath),
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

  void viewCertificate(BuildContext context, String? certificatePath) {
    if (certificatePath == null || certificatePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No certificate available')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Close button
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
              // Certificate image
              Expanded(
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: certificatePath,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 8),
                        Text('Failed to load certificate: $error'),
                      ],
                    ),
                  ),
                ),
              ),
              // Download button (optional)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Open in Browser'),
                      onPressed: () async {
                        try {
                          final Uri url = Uri.parse(certificatePath);
                          if (!await launchUrl(url)) {
                            throw Exception('Could not launch $url');
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error opening URL: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
