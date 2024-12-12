import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:masiha_admin/business_logic/doctorRequest/bloc/doctor_requests_bloc.dart';
import 'package:masiha_admin/business_logic/registration/auth_bloc.dart';
import 'package:masiha_admin/business_logic/registration/auth_states.dart';
import 'package:masiha_admin/presentation/screens/registration/registeration.dart';
import 'package:masiha_admin/presentation/screens/requests/admin_panel_page.dart';
import 'package:masiha_admin/repositories/doctor_request_repository.dart';
import 'package:masiha_admin/services/firebase_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAqFBLGrokWOEbAfHXm-ujRuxGEnYJS9IY",
      projectId: "student-record-edcdf",
      messagingSenderId: "123369036375",
      appId: "1:123369036375:web:fb24ae225680571802e112",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(FirebaseAuthService(
              auth: FirebaseAuth.instance,
              googleSignIn: GoogleSignIn(
                clientId:
                    '123369036375-61p5m9o3ekltsnu97o8c68djpfo35m3b.apps.googleusercontent.com',
              ),
            )),
          ),
          BlocProvider(
            create: (context) => DoctorRequestsBloc(
              DoctorRequestsRepository(FirebaseFirestore.instance),
            ), // Add this line
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Firebase Login',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticatedState) {
                return const AdminPanelPage();
              }
              return const LoginScreen();
            },
          ),
        ));
  }
}
