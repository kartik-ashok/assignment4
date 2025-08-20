import 'dart:convert';

import 'package:http/http.dart' as http;

class PostService {
  Future<List<dynamic>> getPosts() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "User-Agent": "Mozilla/5.0", // some APIs need this
          // If your API works with cookies in browser:
          // "Cookie": "sessionid=xyz; anothercookie=abc",
          // If requires auth token:
          // "Authorization": "Bearer YOUR_TOKEN"
        },
      );

      if (response.statusCode == 200) {
        print(json.decode(response.body));
        List<dynamic> jsondata = json.decode(response.body);
        // print(jsondata.length);
        // print("Data fetching");
        return jsondata;
        // return [];
      } else {
        throw Exception('Failed to fetch posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }
}
