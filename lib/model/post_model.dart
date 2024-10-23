// lib/model/post.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String username;
  final String message;
  final Timestamp timestamp;

  Post({
    required this.username,
    required this.message,
    required this.timestamp,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      username: data['username'] ?? '',
      message: data['message'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
