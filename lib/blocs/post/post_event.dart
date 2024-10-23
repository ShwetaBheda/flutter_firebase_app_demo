import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPosts extends PostEvent {}

class AddPost extends PostEvent {
  final String message;
  final String username;
  final DateTime timestamp; // Add timestamp parameter

  AddPost({required this.message, required this.username, required this.timestamp});

  @override
  List<Object> get props => [message, username, timestamp]; // Include timestamp in props
}
