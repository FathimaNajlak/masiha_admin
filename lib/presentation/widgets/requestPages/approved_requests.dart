import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masiha_admin/business_logic/doctorRequest/bloc/doctor_requests_bloc.dart';
import 'package:masiha_admin/business_logic/doctorRequest/bloc/doctor_requests_event.dart';
import 'package:masiha_admin/business_logic/doctorRequest/bloc/doctor_requests_state.dart';
import 'package:masiha_admin/model/doctor_details_model.dart';
import 'package:masiha_admin/presentation/widgets/doctor_request_card.dart';

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

  void _showDoctorDetailsDialog(dynamic request) {
    // Implementation similar to the pending requests page dialog
  }
}
