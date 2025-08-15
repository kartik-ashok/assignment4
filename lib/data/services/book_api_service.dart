import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../models/book_details.dart';

class BookApiService {
  static const String _baseUrl = 'https://openlibrary.org';

  Future<Book> fetchBooks(String query, {int page = 0, int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/search.json?q=${Uri.encodeComponent(query)}&page=$page&limit=$limit&fields=title,author_name,cover_i,key',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Book.fromJson(data);
      } else {
        throw Exception('Failed to fetch books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

  Future<BookDetails> fetchBookDetails(String workKey) async {
    // workKey example: /works/OL1257866W
    final normalized = workKey.startsWith('/') ? workKey : '/$workKey';
    final url = '$_baseUrl$normalized.json';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return BookDetails.fromJson(data);
      } else {
        throw Exception('Failed to fetch details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching details: $e');
    }
  }
}
