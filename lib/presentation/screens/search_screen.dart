import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Setup animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _fadeController.forward();
    _slideController.forward();

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
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      final provider = Provider.of<BookProvider>(context, listen: false);
      provider.fetchBooks(query);
    }
  }

  Future<void> _onRefresh() async {
    _performSearch(); // call your existing function
    // optionally wait for some async operation if fetchBooks is async
    await Future.delayed(Duration(milliseconds: 100));
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
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SavedBooksScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: Colors.yellowAccent, // spinner color
      backgroundColor: Colors.blue.shade900, // background behind spinner
      displacement: 80, // how far from top it starts
      strokeWidth: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Text(
                    'Book Finder',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
          backgroundColor: Colors.blue[600],
          elevation: 0,
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, -0.5),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _fadeController,
                              curve: const Interval(
                                0.5,
                                1.0,
                                curve: Curves.easeOutCubic,
                              ),
                            ),
                          ),
                      child: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.white),
                        onPressed: _goToSavedBooks,
                        tooltip: 'Saved Books',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Search bar with animations
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, -0.3),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _fadeController,
                            curve: const Interval(
                              0.2,
                              1.0,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                        ),
                    child: Container(
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
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 1.5.h,
                                ),
                              ),
                              onSubmitted: (_) => _performSearch(),
                              textInputAction: TextInputAction.search,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          AnimatedScale(
                            scale: 1.0,
                            duration: const Duration(milliseconds: 150),
                            child: ElevatedButton(
                              onPressed: _performSearch,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[600],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 1.5.h,
                                ),
                                elevation: 3,
                                shadowColor: Colors.orange.withOpacity(0.3),
                              ),
                              child: Text(
                                'Search',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            // Search results with animations
            Expanded(
              child: Consumer<BookProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    // Show loading cards with staggered animation
                    return ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return AnimatedBuilder(
                          animation: _fadeAnimation,
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(0, 0.3),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: _fadeController,
                                        curve: Interval(
                                          (index * 0.1).clamp(0.0, 1.0),
                                          1.0,
                                          curve: Curves.easeOutCubic,
                                        ),
                                      ),
                                    ),
                                child: const LoadingBookCard(),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }

                  if (provider.error.isNotEmpty) {
                    // Show error with animation
                    return AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Center(
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
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      provider.clearError();
                                      if (_searchController.text
                                          .trim()
                                          .isNotEmpty) {
                                        provider.fetchBooks(
                                          _searchController.text.trim(),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Retry'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[600],
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  if (provider.currentBooks.isEmpty) {
                    if (_searchController.text.trim().isNotEmpty) {
                      // Show no results with animation
                      return AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Center(
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
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      // Show initial state with animation
                      return AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedRotation(
                                      turns: 1,
                                      duration: const Duration(seconds: 3),
                                      child: Icon(
                                        Icons.book,
                                        size: 20.w,
                                        color: Colors.blue[300],
                                      ),
                                    ),
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
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }

                  // Show search results with pagination and animations
                  return AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              // Results count and pagination info
                              if (provider.currentBooks.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 2.h,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Found ${provider.totalBooks} books',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Page ${provider.currentPage} of ${provider.totalPages}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              // Pagination controls
                              if (provider.totalPages > 1)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 1.h,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Prev Button
                                      AnimatedScale(
                                        scale: provider.hasPrevPage
                                            ? 1.0
                                            : 0.95,
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        child:
                                            ElevatedButton.icon(
                                              onPressed: provider.hasPrevPage
                                                  ? _prevPage
                                                  : null,
                                              icon: const Icon(
                                                Icons.arrow_back,
                                                size: 18,
                                              ),
                                              label: const Text(
                                                'Prev',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              style:
                                                  ElevatedButton.styleFrom(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 18,
                                                          vertical: 14,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            30,
                                                          ),
                                                    ),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    shadowColor: Colors.black45,
                                                    elevation:
                                                        provider.hasPrevPage
                                                        ? 6
                                                        : 0,
                                                  ).copyWith(
                                                    foregroundColor:
                                                        MaterialStateProperty.all(
                                                          Colors.white,
                                                        ),
                                                  ),
                                            ).wrapWithGradient(
                                              enabled: provider.hasPrevPage,
                                              colors: [
                                                Colors.blue[600]!,
                                                Colors.blue[400]!,
                                              ],
                                            ),
                                      ),

                                      SizedBox(width: 4.w),

                                      // Page Indicator
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4.w,
                                          vertical: 1.2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 6,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
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

                                      // Next Button
                                      AnimatedScale(
                                        scale: provider.hasNextPage
                                            ? 1.0
                                            : 0.95,
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        child:
                                            ElevatedButton(
                                              onPressed: provider.hasNextPage
                                                  ? _nextPage
                                                  : null,
                                              style:
                                                  ElevatedButton.styleFrom(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 20,
                                                          vertical: 14,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            30,
                                                          ),
                                                    ),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    shadowColor: Colors.black45,
                                                    elevation:
                                                        provider.hasNextPage
                                                        ? 6
                                                        : 0,
                                                  ).copyWith(
                                                    foregroundColor:
                                                        MaterialStateProperty.all(
                                                          Colors.white,
                                                        ),
                                                  ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  Text(
                                                    'Next',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                  SizedBox(width: 6),
                                                  Icon(
                                                    Icons.arrow_forward,
                                                    size: 18,
                                                  ),
                                                ],
                                              ),
                                            ).wrapWithGradient(
                                              enabled: provider.hasNextPage,
                                              colors: [
                                                Colors.blue[600]!,
                                                Colors.blue[400]!,
                                              ],
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(height: 1.h),
                              Divider(
                                height: 1,
                                thickness: 0.5,
                                color: Colors.blue[300],
                                indent: 4.w,
                                endIndent: 4.w,
                              ),
                              SizedBox(height: 1.h),

                              // Books list with staggered animations
                              Expanded(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  padding: EdgeInsets.only(bottom: 2.h),
                                  itemCount: provider.currentBooks.length,
                                  itemBuilder: (context, index) {
                                    final bookDoc =
                                        provider.currentBooks[index];
                                    return AnimatedBuilder(
                                      animation: _fadeAnimation,
                                      builder: (context, child) {
                                        return FadeTransition(
                                          opacity: _fadeAnimation,
                                          child: SlideTransition(
                                            position:
                                                Tween<Offset>(
                                                  begin: const Offset(0, 0.3),
                                                  end: Offset.zero,
                                                ).animate(
                                                  CurvedAnimation(
                                                    parent: _fadeController,
                                                    curve: Interval(
                                                      (index * 0.05).clamp(
                                                        0.0,
                                                        1.0,
                                                      ),
                                                      1.0,
                                                      curve:
                                                          Curves.easeOutCubic,
                                                    ),
                                                  ),
                                                ),
                                            child: BookCard(doc: bookDoc),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension GradientButton on Widget {
  Widget wrapWithGradient({
    required bool enabled,
    required List<Color> colors,
  }) {
    if (!enabled) return this;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: this,
    );
  }
}
