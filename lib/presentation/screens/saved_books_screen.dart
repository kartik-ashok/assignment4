import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../providers/book_provider.dart';
import '../widgets/book_card.dart';

class SavedBooksScreen extends StatefulWidget {
  const SavedBooksScreen({super.key});

  @override
  State<SavedBooksScreen> createState() => _SavedBooksScreenState();
}

class _SavedBooksScreenState extends State<SavedBooksScreen> {
  @override
  void initState() {
    super.initState();
    // Load favorites when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BookProvider>(context, listen: false);
      provider.loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Saved Books',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple[600],
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<BookProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 15.w,
                    color: Colors.red[400],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Error: ${provider.error}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.red[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      provider.loadFavorites();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 20.w,
                    color: Colors.purple[300],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'No saved books yet',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Tap the heart icon on any book to save it',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Header with count
              Container(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.purple[600],
                      size: 20.sp,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${provider.favorites.length} saved books',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Books list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 2.h),
                  itemCount: provider.favorites.length,
                  itemBuilder: (context, index) {
                    final book = provider.favorites[index];
                    return BookCard(doc: book);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
