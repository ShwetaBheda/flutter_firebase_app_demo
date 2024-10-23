// lib/services/post_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task/model/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Post>> fetchPosts() {
    return _firestore.collection('posts').orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromDocument(doc);
      }).toList();
    });
  }

  Future<void> addPost({required String message, required String username}) async {
    await _firestore.collection('posts').add({
      'message': message,
      'username': username,
      'timestamp': DateTime.now(), // Save server timestamp
    });
  }
}
