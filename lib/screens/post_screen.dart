import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/blocs/post/post_bloc.dart';
import 'package:flutter_task/blocs/post/post_event.dart';
import 'package:flutter_task/blocs/post/post_state.dart';
import 'package:flutter_task/common_widgets/post_input.dart';
import 'package:flutter_task/services/post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postService = PostService();

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Chat',
            style: TextStyle(color: Colors.black),
          ),
          leading: const SizedBox(),
          backgroundColor: Colors.greenAccent[100],
          centerTitle: true,
        ),
        body: BlocProvider(
          create: (_) => PostBloc(postService)..add(LoadPosts()),
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
                        reverse: true,
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          final isCurrentUser =
                              post.username == _auth.currentUser?.displayName;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: Align(
                              alignment: isCurrentUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.7), // Limits message width
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isCurrentUser
                                      ? Colors.greenAccent[100]
                                      : Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(12),
                                    topRight: const Radius.circular(12),
                                    bottomLeft: isCurrentUser
                                        ? const Radius.circular(12)
                                        : Radius.zero,
                                    bottomRight: isCurrentUser
                                        ? Radius.zero
                                        : const Radius.circular(12),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    )
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: isCurrentUser
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    isCurrentUser
                                        ? const SizedBox()
                                        : Text(
                                            post.username,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isCurrentUser
                                                  ? Colors.black
                                                  : Colors.black54,
                                            ),
                                          ),
                                    isCurrentUser
                                        ? const SizedBox()
                                        : const SizedBox(height: 5),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: isCurrentUser
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            post.message,
                                            style: TextStyle(
                                              color: isCurrentUser
                                                  ? Colors.black
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          formatTimestamp(post.timestamp),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
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
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final hour = dateTime.hour % 12 == 0
        ? 12
        : dateTime.hour % 12; // Convert to 12-hour format
    final formattedTime =
        '$hour:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
    return formattedTime;
  }
}
