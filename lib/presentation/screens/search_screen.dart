import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../providers/book_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/shimmer_book_card.dart';
import 'saved_books_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      final provider = Provider.of<BookProvider>(context, listen: false);
      provider.fetchBooks(query);
    }
  }

  void _nextPage() {
    final provider = Provider.of<BookProvider>(context, listen: false);
    provider.nextPage();
  }

  void _prevPage() {
    final provider = Provider.of<BookProvider>(context, listen: false);
    provider.prevPage();
  }

  void _goToSavedBooks() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SavedBooksScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController.clear();
    
    // Use addPostFrameCallback to avoid calling provider methods during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BookProvider>(context, listen: false);
      provider.clearBooks();
      
      _searchController.addListener(() {
        if (_searchController.text.isEmpty) {
          provider.clearBooks();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Book Finder',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: _goToSavedBooks,
            tooltip: 'Saved Books',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.blue[600],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for books...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.sp,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[400],
                        size: 20.sp,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                    ),
                    onSubmitted: (_) => _performSearch(),
                    textInputAction: TextInputAction.search,
                  ),
                ),
                SizedBox(width: 2.w),
                ElevatedButton(
                  onPressed: _performSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                  child: Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Search results
          Expanded(
            child: Consumer<BookProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  // Show loading cards
                  return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) => const LoadingBookCard(),
                  );
                }

                if (provider.error.isNotEmpty) {
                  // Show error
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
                            if (_searchController.text.trim().isNotEmpty) {
                              provider.fetchBooks(_searchController.text.trim());
                            }
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.currentBooks.isEmpty) {
                  if (_searchController.text.trim().isNotEmpty) {
                    // Show no results
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 15.w,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'No books found for "${_searchController.text.trim()}"',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Show initial state
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.book, size: 20.w, color: Colors.blue[300]),
                          SizedBox(height: 3.h),
                          Text(
                            'Search for your favorite books',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Use the search bar above to find books',
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
                }

                // Show search results with pagination
                return Column(
                  children: [
                    // Results count and pagination info
                    if (provider.currentBooks.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                        child: Row(
                          children: [
                            Text(
                              'Found ${provider.totalBooks} books',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Page ${provider.currentPage} of ${provider.totalPages}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Pagination controls
                    if (provider.totalPages > 1)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: provider.hasPrevPage ? _prevPage : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Prev'),
                            ),
                            SizedBox(width: 4.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                '${provider.currentPage} / ${provider.totalPages}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            ElevatedButton(
                              onPressed: provider.hasNextPage ? _nextPage : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Next'),
                            ),
                          ],
                        ),
                      ),
                    // Books list
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.only(bottom: 2.h),
                        itemCount: provider.currentBooks.length,
                        itemBuilder: (context, index) {
                          final bookDoc = provider.currentBooks[index];
                          return BookCard(doc: bookDoc);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
