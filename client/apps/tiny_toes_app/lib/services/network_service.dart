import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  Future<List<dynamic>> fetchAlbums(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId/albums'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch albums');
    }
  }

  Future<List<dynamic>> fetchPhotos(int albumId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/albums/$albumId/photos'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch photos');
    }
  }
}
