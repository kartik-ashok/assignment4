import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'data/services/book_api_service.dart';
import 'data/services/database_service.dart';
import 'data/repositories/book_repository.dart';
import 'domain/usecases/search_books_usecase.dart';
import 'presentation/providers/book_provider.dart';
import 'presentation/screens/search_screen.dart';

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
        
        // Repository
        Provider<BookRepository>(
          create: (context) => BookRepository(
            apiService: context.read<BookApiService>(),
            databaseService: context.read<DatabaseService>(),
          ),
        ),
        
        // Use Cases
        Provider<FetchBooksUseCase>(
          create: (context) => FetchBooksUseCase(
            context.read<BookRepository>(),
          ),
        ),
        Provider<GetFavoritesUseCase>(
          create: (context) => GetFavoritesUseCase(
            context.read<BookRepository>(),
          ),
        ),
        Provider<ToggleFavoriteUseCase>(
          create: (context) => ToggleFavoriteUseCase(
            context.read<BookRepository>(),
          ),
        ),
        Provider<CheckFavoriteUseCase>(
          create: (context) => CheckFavoriteUseCase(
            context.read<BookRepository>(),
          ),
        ),
        Provider<GetBookDetailsUseCase>(
          create: (context) => GetBookDetailsUseCase(
            context.read<BookRepository>(),
          ),
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
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            home: const SearchScreen(),
          );
        },
      ),
    );
  }
}
