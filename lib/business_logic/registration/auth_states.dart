import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthAuthenticatedState extends AuthState {
  final User user;

  AuthAuthenticatedState(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
