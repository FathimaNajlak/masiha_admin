import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:masiha_admin/model/doctor_details_model.dart';

class DoctorRequestCard extends StatelessWidget {
  final DoctorDetailsModel request;
  final RequestStatus currentStatus;
  final VoidCallback? onTap;
  final VoidCallback? onApprove;
  final VoidCallback? onDecline;

  const DoctorRequestCard({
    super.key,
    required this.request,
    required this.currentStatus,
    this.onTap,
    this.onApprove,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Image
              _buildDoctorImage(),
              const SizedBox(width: 16),

              // Doctor Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDoctorName(context),
                    const SizedBox(height: 8),
                    _buildDoctorDetails(),
                    const SizedBox(height: 12),
                    _buildStatusBadge(),
                  ],
                ),
              ),

              // Action Buttons
              if (currentStatus == RequestStatus.pending) _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: request.imagePath != null
            ? CachedNetworkImage(
                imageUrl: request.imagePath!,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildImagePlaceholder(),
                errorWidget: (context, url, error) => _buildImagePlaceholder(),
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: Icon(
        Icons.person,
        size: 40,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildDoctorName(BuildContext context) {
    return Text(
      request.fullName ?? 'Unknown Doctor',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildDoctorDetails() {
    final TextStyle detailStyle = TextStyle(
      fontSize: 14,
      color: Colors.grey[600],
      height: 1.5,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (request.hospitalName != null) ...[
          Row(
            children: [
              Icon(Icons.local_hospital, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(request.hospitalName!, style: detailStyle),
              ),
            ],
          ),
        ],
        if (request.yearOfExperience != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.work_history, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text('${request.yearOfExperience} years', style: detailStyle),
            ],
          ),
        ],
        if (request.specialty != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.medical_services, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(request.specialty!, style: detailStyle),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color statusColor;
    String statusText;

    switch (currentStatus) {
      case RequestStatus.pending:
        statusColor = Colors.orange;
        statusText = 'Pending';
        break;
      case RequestStatus.approved:
        statusColor = Colors.green;
        statusText = 'Approved';
        break;
      case RequestStatus.rejected:
        statusColor = Colors.red;
        statusText = 'Rejected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.5)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: onApprove,
          icon: const Icon(Icons.check, size: 16),
          label: const Text('Approve'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: const Size(100, 36),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onDecline,
          icon: const Icon(Icons.close, size: 16),
          label: const Text('Decline'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: const Size(100, 36),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
