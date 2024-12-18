import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignupEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;

  SignupEvent(
      {required this.email, required this.password, required this.username});

  @override
  List<Object?> get props => [email, password, username];
}

class GoogleSignInEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
