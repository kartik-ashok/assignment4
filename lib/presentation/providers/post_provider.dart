import 'package:assignment4/data/models/post.dart';
import 'package:assignment4/domain/usecases/posts_usecases.dart';
import 'package:flutter/material.dart';

class PostProvider extends ChangeNotifier {
  final PostsUsecases _postUsecases;
  final ToggleFavoriteUseCasePost _toggleFavoriteUseCase;
  final CheckFavoriteUseCasePost _checkFavoriteUseCase;
  final GetFavoritesUseCasePost _getFavoritesUseCase;

  List<PostDoc> _currentBooks = [];
  List<PostDoc> _favorites = [];

  bool _isLoading = false;
  String _error = '';

  PostProvider({
    required PostsUsecases postUsecases,
    required ToggleFavoriteUseCasePost toggleFavoriteUseCase,
    required CheckFavoriteUseCasePost checkFavoriteUseCase,
    required GetFavoritesUseCasePost getFavoritesUseCase,
  }) : _postUsecases = postUsecases,
       _toggleFavoriteUseCase = toggleFavoriteUseCase,
       _checkFavoriteUseCase = checkFavoriteUseCase,
       _getFavoritesUseCase = getFavoritesUseCase;
  List<PostDoc> get currentBooks => _currentBooks;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      // _currentBooks = await _postUsecases.execute();
      final posts = await _postUsecases.execute(); // returns List<Posts>
      // map into PostDoc list

      _currentBooks = posts.map((p) {
        // Check if the post is already a favorite
        final isFav = _checkFavoriteUseCase.execute(p.id ?? 0);
        print("Post with id ${p.id} is favorite: $isFav");

        // Create PostDoc instance
        // check if already saved as favorite
        return PostDoc(
          id: p.id,
          userId: p.userId,
          title: p.title,
          body: p.body,
          isFavorite: false, // default, will update later
        );
      }).toList();
      _error = '';
      // Update favorite status for each book
      await _updateFavoriteStatus();
    } catch (e) {
      _error = 'Failed to fetch posts: $e';
      _currentBooks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // // Add to favorites (only add, no removal)
  // Future<void> addToFavorites(PostDoc book) async {
  //   try {
  //     // Create a copy with isFavorite = true
  //     final updatedBook = book.copyWith(isFavorite: true);

  //     // Save to DB (use addFavorite instead of checkFavorite)
  //     await _checkFavoriteUseCase.execute(updatedBook);

  //     // Add to favorites list if not already present
  //     if (!_favorites.any((b) => b.id == book.id)) {
  //       _favorites.add(updatedBook);
  //     }

  //     // Update in current books list
  //     final bookIndex = _currentBooks.indexWhere((b) => b.id == book.id);
  //     if (bookIndex != -1) {
  //       _currentBooks[bookIndex] = Posts(
  //         userId: updatedBook.userId,
  //         id: updatedBook.id,
  //         title: updatedBook.title,
  //         body: updatedBook.body,
  //         // Add other fields as necessary to match Posts constructor
  //       );
  //     }

  //     notifyListeners();
  //   } catch (e) {
  //     _error = e.toString();
  //     notifyListeners();
  //   }
  // }

  Future<void> loadFavorites() async {
    try {
      _favorites = await _getFavoritesUseCase.execute();
      print("Favorites loaded: ${_favorites.length}");
      print("Favorites ID loaded: ${_favorites.map((f) => f.id).toList()}");
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Toggle favorite
  Future<void> toggleFavorite(PostDoc book) async {
    print("Toggling favorite for book: ${book.isFavorite}");
    try {
      await _toggleFavoriteUseCase.execute(book);

      // Update the book's favorite status
      final updatedBook = book.copyWith(isFavorite: !book.isFavorite);

      // Update in current books list
      final bookIndex = _currentBooks.indexWhere((b) => b.id == book.id);
      if (bookIndex != -1) {
        _currentBooks[bookIndex] = updatedBook;
      }

      // Update in favorites list
      if (updatedBook.isFavorite) {
        _favorites.add(updatedBook);
      } else {
        _favorites.removeWhere((b) => b.id == book.id);
      }
      // Update favorite status in database
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Update favorite status for current books
  Future<void> _updateFavoriteStatus() async {
    for (int i = 0; i < _currentBooks.length; i++) {
      final book = _currentBooks[i];
      print('Checking favorite status for book: ${book.id}');
      if (book.id != null) {
        print("HELLLo");
        final isFavorite = await _checkFavoriteUseCase.execute(book.id!);
        _currentBooks[i] = book.copyWith(isFavorite: isFavorite);
      }
    }
    notifyListeners();
  }
}
