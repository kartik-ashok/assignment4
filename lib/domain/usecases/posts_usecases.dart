import 'package:assignment4/data/models/post.dart';
import 'package:assignment4/data/repositories/post_repository.dart';

class PostsUsecases {
  final PostRepository _postRespository;

  PostsUsecases(this._postRespository);
  Future<List<Posts>> execute() async {
    return await _postRespository.fetchPosts();
  }
}

class CheckFavoriteUseCasePost {
  final PostRepository _repository;

  CheckFavoriteUseCasePost(this._repository);

  Future execute(int id) async {
    await _repository.isFavorite(id);
  }
}

class ToggleFavoriteUseCasePost {
  final PostRepository _repository;

  ToggleFavoriteUseCasePost(this._repository);

  Future<void> execute(PostDoc book) async {
    await _repository.toggleFavorite(book);
  }
}

class GetFavoritesUseCasePost {
  final PostRepository _repository;

  GetFavoritesUseCasePost(this._repository);

  Future<List<PostDoc>> execute() async {
    return await _repository.getFavorites();
  }
}
