// lib/screens/home_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/blocs/post/post_bloc.dart';
import 'package:flutter_task/blocs/post/post_event.dart';
import 'package:flutter_task/blocs/post/post_state.dart';
import 'package:flutter_task/common_widgets/post_input.dart';
import 'package:flutter_task/services/post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final postService = PostService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.blue,
      ),
      body: BlocProvider(
        create: (_) => PostBloc(postService)..add(LoadPosts()), // Initialize BLoC and load posts
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is PostLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PostLoaded) {
                    final posts = state.posts;

                    if (posts.isEmpty) {
                      return const Center(child: Text('No posts yet.'));
                    }

                    return ListView.builder(
                      reverse: true, // Latest messages at the bottom
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        final isCurrentUser = post.username == _auth.currentUser?.displayName;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isCurrentUser ? Colors.blue : Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    post.message,
                                    style: TextStyle(
                                      color: isCurrentUser ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    formatTimestamp(post.timestamp),
                                    style: TextStyle(
                                      color: isCurrentUser ? Colors.white70 : Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is PostError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const Center(child: Text('No posts yet.'));
                },
              ),
            ),
            PostInput(), // Input field at the bottom
          ],
        ),
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12; // Convert to 12-hour format
    final formattedTime = '$hour:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
    return formattedTime;
  }
}
