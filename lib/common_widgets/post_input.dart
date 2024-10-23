// lib/common_widgets/post_input.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/blocs/post/post_bloc.dart';
import 'package:flutter_task/blocs/post/post_event.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostInput extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize FirebaseAuth

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final message = _controller.text;

              // Fetch the current user's display name
              final user = _auth.currentUser;
              final username = user != null ? user.displayName ?? 'Anonymous' : 'Anonymous'; // Fallback to 'Anonymous' if no display name is set

              if (message.isNotEmpty) {
                context.read<PostBloc>().add(AddPost(message: message, username: username, timestamp: DateTime.now()));
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
