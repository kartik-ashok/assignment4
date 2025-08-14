import 'package:assignment4/presentation/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
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
            MaterialPageRoute(
              builder: (_) => BookDetailScreen(workKey: doc.key!),
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
            // Book cover
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: doc.coverI != null
                  ? Image.network(
                      "https://covers.openlibrary.org/b/id/${doc.coverI}-M.jpg",
                      width: 30.w,
                      // height: 20.h,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 15.w,
                          height: 20.h,
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 15.w,
                          height: 20.h,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error, color: Colors.grey),
                        );
                      },
                    )
                  : Container(
                      width: 30.w,
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
                  Text(
                    doc.title ?? 'Unknown Title',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  if (doc.authorName != null && doc.authorName!.isNotEmpty)
                    Text(
                      'Author: ${doc.authorName!.join(', ')}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 1.h),
                  // Heart button
                  Row(
                    children: [
                      Consumer<BookProvider>(
                        builder: (context, provider, child) {
                          return IconButton(
                            icon: Icon(
                              doc.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: doc.isFavorite ? Colors.red : Colors.grey,
                              size: 22.sp,
                            ),
                            onPressed: () {
                              provider.toggleFavorite(doc);
                            },
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
