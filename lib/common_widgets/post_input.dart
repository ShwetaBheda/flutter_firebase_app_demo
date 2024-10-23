import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/blocs/post/post_bloc.dart';
import 'package:flutter_task/blocs/post/post_event.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostInput extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize FirebaseAuth

  PostInput({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              textCapitalization: TextCapitalization
                  .sentences, // Auto-capitalization for messages
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              final message = _controller.text;

              // Fetch the current user's display name
              final user = _auth.currentUser;
              final username = user != null
                  ? user.displayName ?? 'Anonymous'
                  : 'Anonymous'; // Fallback to 'Anonymous' if no display name is set

              if (message.isNotEmpty) {
                context.read<PostBloc>().add(
                      AddPost(
                        message: message,
                        username: username,
                        timestamp: DateTime.now(),
                      ),
                    );
                _controller.clear();
              }
            },
            child: const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.greenAccent,
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
