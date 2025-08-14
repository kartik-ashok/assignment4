import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../providers/book_provider.dart';

class BookDetailScreen extends StatefulWidget {
  final String workKey; // e.g., /works/OL1257866W

  const BookDetailScreen({super.key, required this.workKey});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BookProvider>(context, listen: false);
      provider.fetchBookDetails(widget.workKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Details',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
        centerTitle: true,
      ),
      body: Consumer<BookProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error.isNotEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(6.w),
                child: Text(
                  provider.error,
                  style: TextStyle(fontSize: 12.sp, color: Colors.red[600]),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final details = provider.details;
          if (details == null) {
            return const SizedBox.shrink();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (details.largeCoverUrl != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        details.largeCoverUrl!,
                        width: 60.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(height: 2.h),
                Text(
                  details.title ?? 'Untitled',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (details.firstPublishDate != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    'First published: ${details.firstPublishDate}',
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[700]),
                  ),
                ],
                SizedBox(height: 2.h),
                if (details.description != null) ...[
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    details.description!,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  SizedBox(height: 2.h),
                ],
                if (details.subjects.isNotEmpty) ...[
                  Text(
                    'Subjects',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Wrap(
                    spacing: 6,
                    runSpacing: -8,
                    children: details.subjects
                        .map((s) => Chip(label: Text(s)))
                        .toList(),
                  )
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}


