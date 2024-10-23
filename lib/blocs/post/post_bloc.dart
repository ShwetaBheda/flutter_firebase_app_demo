import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/blocs/post/post_event.dart';
import 'package:flutter_task/blocs/post/post_state.dart';
import 'package:flutter_task/services/post_service.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostService postService;

  PostBloc(this.postService) : super(PostLoading()) {
    // Using 'on' instead of 'add' for handling events
    on<LoadPosts>((event, emit) async {
      emit(PostLoading());
      try {
        await for (final posts in postService.fetchPosts()) {
          emit(PostLoaded(posts));
        }
      } catch (e, stackTrace) {
        emit(PostError('Failed to load posts.'));
        // You can also log the error and stack trace if needed
        print('Error: $e\nStackTrace: $stackTrace');
      }
    });

    on<AddPost>((event, emit) async {
      try {
        await postService.addPost(
          message: event.message,
          username: event.username,
        );
        // Optionally, you can trigger loading posts again or handle it differently
      } catch (e, stackTrace) {
        emit(PostError('Failed to add post.'));
        // Log the error and stack trace
        print('Error: $e\nStackTrace: $stackTrace');
      }
    });
  }
}
