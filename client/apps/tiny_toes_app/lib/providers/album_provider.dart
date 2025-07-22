import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/album.dart';

enum AlbumsState { loading, success, failure }

class AlbumsProvider with ChangeNotifier {
  List<Album> _albums = [];
  AlbumsState _state = AlbumsState.loading;

  List<Album> get albums => _albums;
  AlbumsState get state => _state;

  Future<void> fetchAlbums(int userId) async {
    _state = AlbumsState.loading;
    notifyListeners();

    final url = Uri.parse('https://jsonplaceholder.typicode.com/users/$userId/albums');
    print('➡️ Fetching albums for userId: $userId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'tinytoes-flutter-app',
        },
      );

      print('✅ Albums response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _albums = data.map((json) => Album.fromJson(json)).toList();
        print('✅ Albums loaded: ${_albums.length}');
        _state = AlbumsState.success;
      } else {
        print('❌ Failed with status: ${response.statusCode}');
        _state = AlbumsState.failure;
      }
    } catch (e) {
      print('❌ Albums network error: $e');
      _state = AlbumsState.failure;
    }

    notifyListeners();
  }
}
