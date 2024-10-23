import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/blocs/post/post_event.dart';
import 'package:flutter_task/blocs/post/post_state.dart';
import 'package:flutter_task/services/post_service.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostService postService;

  PostBloc(this.postService) : super(PostLoading()) {
    // Load posts when the bloc is initialized
    on<LoadPosts>((event, emit) async {
      emit(PostLoading());
      try {
        await for (final posts in postService.fetchPosts()) {
          emit(PostLoaded(posts));
        }
      } catch (e, stackTrace) {
        emit(PostError('Failed to load posts.'));

        if (kDebugMode) {
          print('Error: $e\nStackTrace: $stackTrace');
        }
      }
    });

    // Add post when the user sends a message
    on<AddPost>((event, emit) async {
      try {
        await postService.addPost(
          message: event.message,
          username: event.username,
        );
      } catch (e, stackTrace) {
        emit(PostError('Failed to add post.'));

        if (kDebugMode) {
          print('Error: $e\nStackTrace: $stackTrace');
        }
      }
    });
  }
}
