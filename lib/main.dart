import 'package:assignment4/data/repositories/post_repository.dart';
import 'package:assignment4/data/services/post_database_service.dart';
import 'package:assignment4/data/services/post_service.dart';
import 'package:assignment4/domain/usecases/posts_usecases.dart';
import 'package:assignment4/presentation/providers/post_provider.dart';
import 'package:assignment4/presentation/screens/dummy.dart';
import 'package:assignment4/presentation/screens/geo_locator.dart';
import 'package:assignment4/presentation/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'data/services/book_api_service.dart';
import 'data/services/database_service.dart';
import 'data/repositories/book_repository.dart';
import 'domain/usecases/search_books_usecase.dart';
import 'presentation/providers/book_provider.dart';

void main() {
  runApp(const BookFinderApp());
}

class BookFinderApp extends StatelessWidget {
  const BookFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<BookApiService>(create: (_) => BookApiService()),
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        Provider<PostService>(create: (_) => PostService()),
        Provider<PostDatabaseService>(create: (_) => PostDatabaseService()),

        // Repository
        Provider<BookRepository>(
          create: (context) => BookRepository(
            apiService: context.read<BookApiService>(),
            databaseService: context.read<DatabaseService>(),
          ),
        ),

        // Repository
        Provider<PostRepository>(
          create: (context) => PostRepository(
            postService: PostService(),
            postDatabaseService: PostDatabaseService(),
          ),
        ),

        // Use Cases
        Provider<FetchBooksUseCase>(
          create: (context) =>
              FetchBooksUseCase(context.read<BookRepository>()),
        ),
        Provider<GetFavoritesUseCase>(
          create: (context) =>
              GetFavoritesUseCase(context.read<BookRepository>()),
        ),
        Provider<ToggleFavoriteUseCase>(
          create: (context) =>
              ToggleFavoriteUseCase(context.read<BookRepository>()),
        ),
        Provider<CheckFavoriteUseCase>(
          create: (context) =>
              CheckFavoriteUseCase(context.read<BookRepository>()),
        ),
        Provider<GetBookDetailsUseCase>(
          create: (context) =>
              GetBookDetailsUseCase(context.read<BookRepository>()),
        ),
        Provider<GetFavoritesUseCasePost>(
          create: (context) =>
              GetFavoritesUseCasePost(context.read<PostRepository>()),
        ),

        // Use Cases for Post
        Provider<PostsUsecases>(
          create: (context) => PostsUsecases(context.read<PostRepository>()),
        ),

        // Use Case for checking post favorites
        Provider<CheckFavoriteUseCasePost>(
          create: (context) =>
              CheckFavoriteUseCasePost(context.read<PostRepository>()),
        ),

        // Provider
        ChangeNotifierProvider<BookProvider>(
          create: (context) => BookProvider(
            fetchBooksUseCase: context.read<FetchBooksUseCase>(),
            getFavoritesUseCase: context.read<GetFavoritesUseCase>(),
            toggleFavoriteUseCase: context.read<ToggleFavoriteUseCase>(),
            checkFavoriteUseCase: context.read<CheckFavoriteUseCase>(),
            getBookDetailsUseCase: context.read<GetBookDetailsUseCase>(),
          ),
        ),

        // Provider for Post
        ChangeNotifierProvider<PostProvider>(
          create: (context) => PostProvider(
            checkFavoriteUseCase: context.read<CheckFavoriteUseCasePost>(),
            postUsecases: context.read<PostsUsecases>(),
            toggleFavoriteUseCase: ToggleFavoriteUseCasePost(
              context.read<PostRepository>(),
            ),
            getFavoritesUseCase: context.read<GetFavoritesUseCasePost>(),
          ),
        ),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            title: 'Book Finder',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            // home: const SearchScreen(),
            home: const DummyScreen(),
          );
        },
      ),
    );
  }
}
