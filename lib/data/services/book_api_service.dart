import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookApiService {
  static const String _baseUrl = 'https://openlibrary.org';

  Future<Book> fetchBooks(String query, {int page = 0, int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://openlibrary.org/search.json?q=the&limit=20&fields=title,author_name,cover_i',
        ),
        // Uri.parse(
        //   '$_baseUrl/search.json?q=${Uri.encodeComponent(query)}&page=$page&limit=$limit&fields=title,author_name,cover_i',
        // ),
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
}
