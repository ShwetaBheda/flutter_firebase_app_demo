// auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/blocs/auth_event.dart';
import 'package:flutter_task/blocs/auth_state.dart';

import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc(this._authService) : super(AuthInitial()) {
    // Sign Up Handler
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // Call the registration service
        await _authService.registration(
          email: event.email,
          password: event.password,
          username: event.username,
        );

        // Store the username in Firestore after successful registration
        await _firestore.collection('users').add({
          'username': event.username,
          'email': event.email,
        });

        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });

    // Login Handler
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // Call the login service
        await _authService.login(
          email: event.email,
          password: event.password,
        );

        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });
  }
}
