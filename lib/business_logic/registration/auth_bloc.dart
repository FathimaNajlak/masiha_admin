import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_states.dart';
import '../../services/firebase_auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthService _authService;

  AuthBloc(this._authService) : super(AuthInitialState()) {
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
    on<GoogleSignInEvent>(_onGoogleSignIn);
    on<LogoutEvent>(_onLogout);
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final user = await _authService.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (user != null) {
        emit(AuthAuthenticatedState(user));
      } else {
        emit(AuthErrorState('Login failed'));
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  void _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final user = await _authService.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
        username: event.username,
      );

      if (user != null) {
        emit(AuthAuthenticatedState(user));
      } else {
        emit(AuthErrorState('Signup failed'));
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  void _onGoogleSignIn(GoogleSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final user = await _authService.signInWithGoogle();

      if (user != null) {
        emit(AuthAuthenticatedState(user));
      } else {
        emit(AuthErrorState('Google Sign-In failed'));
      }
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await _authService.signOut();
    emit(AuthInitialState());
  }
}
