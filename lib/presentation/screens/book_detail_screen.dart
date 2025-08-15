import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/book_provider.dart';

class AnimatedEntry extends StatelessWidget {
  final Widget child;
  final Animation<double> fadeAnimation;
  final AnimationController slideController;
  final double startOffsetX;
  final double delayStart;

  const AnimatedEntry({
    Key? key,
    required this.child,
    required this.fadeAnimation,
    required this.slideController,
    this.startOffsetX = -0.5,
    this.delayStart = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fadeAnimation,
      builder: (context, _) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: Offset(startOffsetX, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: slideController,
                    curve: Interval(
                      delayStart,
                      1.0,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                ),
            child: child,
          ),
        );
      },
    );
  }
}

class BookDetailScreen extends StatefulWidget {
  final String workKey;

  const BookDetailScreen({super.key, required this.workKey});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookProvider>(
        context,
        listen: false,
      ).fetchBookDetails(widget.workKey);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Provider.of<BookProvider>(
      context,
      listen: false,
    ).fetchBookDetails(widget.workKey);
  }

  EdgeInsets responsivePadding({double horizontal = 4, double vertical = 2}) =>
      EdgeInsets.symmetric(horizontal: horizontal.w, vertical: vertical.h);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) => FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              'Book Details',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.deepPurple[600],
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: Colors.deepPurple[600],
        child: Consumer<BookProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) return _buildLoading();
            if (provider.error.isNotEmpty) return _buildError(provider);

            final details = provider.details;
            if (details == null) return const SizedBox.shrink();

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: responsivePadding(vertical: 2, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Cover
                  if (details.largeCoverUrl != null)
                    Center(
                      child: Hero(
                        tag: 'book-cover-${widget.workKey}',
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: details.largeCoverUrl!,
                              width: 70.w,
                              height: 40.h,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 70.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 70.w,
                                height: 40.h,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.error,
                                  color: Colors.grey,
                                ),
                              ),
                              fadeInDuration: const Duration(milliseconds: 500),
                              fadeInCurve: Curves.easeInOut,
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 3.h),

                  // Title
                  if (details.title != null)
                    AnimatedEntry(
                      fadeAnimation: _fadeAnimation,
                      slideController: _slideController,
                      delayStart: 0.2,
                      child: Text(
                        details.title!,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  SizedBox(height: 2.h),

                  // First Publish Date
                  if (details.firstPublishDate != null)
                    AnimatedEntry(
                      fadeAnimation: _fadeAnimation,
                      slideController: _slideController,
                      delayStart: 0.3,
                      child: Container(
                        padding: responsivePadding(horizontal: 3, vertical: 1),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple[100]!,
                              Colors.deepPurple[50]!,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'First Published: ${details.firstPublishDate}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.deepPurple[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 3.h),

                  // Description
                  if (details.description != null)
                    AnimatedEntry(
                      fadeAnimation: _fadeAnimation,
                      slideController: _slideController,
                      delayStart: 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            padding: responsivePadding(
                              horizontal: 3,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Text(
                              details.description!,
                              style: TextStyle(fontSize: 15.sp, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 3.h),

                  // Subjects
                  if (details.subjects.isNotEmpty)
                    AnimatedEntry(
                      fadeAnimation: _fadeAnimation,
                      slideController: _slideController,
                      delayStart: 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Subjects',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: details.subjects.map((subject) {
                              return Container(
                                padding: responsivePadding(
                                  horizontal: 3,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[100]!,
                                      Colors.blue[50]!,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  subject,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 4.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoading() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedRotation(
          turns: 1,
          duration: const Duration(seconds: 2),
          child: Icon(Icons.book, size: 15.w, color: Colors.deepPurple[300]),
        ),
        SizedBox(height: 2.h),
        Text(
          'Loading book details...',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
      ],
    ),
  );

  Widget _buildError(BookProvider provider) => Center(
    child: Padding(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 15.w, color: Colors.red[400]),
          SizedBox(height: 2.h),
          Text(
            provider.error,
            style: TextStyle(fontSize: 12.sp, color: Colors.red[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          ElevatedButton.icon(
            onPressed: () {
              provider.clearError();
              _onRefresh();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
