import 'package:assignment4/presentation/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/book.dart';
import '../screens/book_detail_screen.dart';

class BookCard extends StatelessWidget {
  final BookDoc doc;

  const BookCard({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (doc.key != null) {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  BookDetailScreen(workKey: doc.key!),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOutCubic;
                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Book cover with Hero animation
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: doc.coverI != null
                  ? Hero(
                      tag: 'book-cover-${doc.key}',
                      child: CachedNetworkImage(
                        imageUrl: "https://covers.openlibrary.org/b/id/${doc.coverI}-M.jpg",
                        width: 30.w,
                        height: 20.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 30.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 30.w,
                          height: 20.h,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error, color: Colors.grey),
                        ),
                        fadeInDuration: const Duration(milliseconds: 300),
                        fadeOutDuration: const Duration(milliseconds: 200),
                      ),
                    )
                  : Container(
                      width: 30.w,
                      height: 20.h,
                      color: Colors.grey[300],
                      child: const Icon(Icons.book, color: Colors.grey),
                    ),
            ),
            SizedBox(width: 4.w),
            // Book details + Heart button
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    child: Text(
                      doc.title ?? 'Unknown Title',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  if (doc.authorName != null && doc.authorName!.isNotEmpty)
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                      child: Text(
                        'Author: ${doc.authorName!.join(', ')}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  SizedBox(height: 1.h),
                  // Heart button with scale animation
                  Row(
                    children: [
                      Consumer<BookProvider>(
                        builder: (context, provider, child) {
                          return AnimatedScale(
                            scale: doc.isFavorite ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: IconButton(
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  doc.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  key: ValueKey(doc.isFavorite),
                                  color: doc.isFavorite ? Colors.red : Colors.grey,
                                  size: 22.sp,
                                ),
                              ),
                              onPressed: () {
                                provider.toggleFavorite(doc);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
