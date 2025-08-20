import 'package:assignment4/data/models/post.dart';
import 'package:assignment4/data/services/post_database_service.dart';
import 'package:assignment4/data/services/post_service.dart';

class PostRepository {
  final PostService _postService;
  final PostDatabaseService _postDatabaseService;

  PostRepository({
    PostService? postService,
    PostDatabaseService? postDatabaseService,
  }) : _postService = postService ?? PostService(),
       _postDatabaseService = postDatabaseService ?? PostDatabaseService();

  Future<List<Posts>> fetchPosts() async {
    try {
      final jsonData = await _postService.getPosts(); // raw List<dynamic>
      final posts = jsonData.map((e) => Posts.fromJson(e)).toList();
      print(posts);
      return posts;
    } catch (e) {
      throw Exception('Error in repository while fetching posts: $e');
    }
  }

  Future<void> toggleFavorite(PostDoc book) async {
    try {
      if (book.isFavorite) {
        await _postDatabaseService.removeFavorite(book.id);
      } else {
        await _postDatabaseService.insertFavorite(book);
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  Future<List<PostDoc>> getFavorites() async {
    try {
      return await _postDatabaseService.getFavorites();
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  // Future<void> addToFavorites(PostDoc book) async {
  //   try {
  //     await _postDatabaseService.insertFavorite(book);
  //   } catch (e) {
  //     throw Exception('Failed to add to favorites: $e');
  //   }
  // }
  Future<bool> isFavorite(int bookKey) async {
    try {
      return await _postDatabaseService.isFavorite(bookKey);
    } catch (e) {
      throw Exception('Failed to check favorite status: $e');
    }
  }

  Future<void> removeFromFavorites(int id) async {
    try {
      await _postDatabaseService.removeFavorite(id);
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }
}
