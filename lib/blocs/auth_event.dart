

import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String username; // Added username field

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.username, // Include in constructor
  });

  @override
  List<Object> get props => [email, password, username];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
