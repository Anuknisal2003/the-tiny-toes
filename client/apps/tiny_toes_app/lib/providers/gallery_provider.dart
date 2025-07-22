import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/photo.dart';

enum GalleryState { loading, success, failure }

class GalleryProvider with ChangeNotifier {
  List<Photo> _photos = [];
  GalleryState _state = GalleryState.loading;

  List<Photo> get photos => _photos;
  GalleryState get state => _state;

  Future<void> fetchPhotos(int albumId) async {
    _state = GalleryState.loading;
    notifyListeners();

    final url = Uri.parse('https://jsonplaceholder.typicode.com/albums/$albumId/photos');
    print('➡️ Fetching photos for albumId: $albumId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'tinytoes-flutter-app',
        },
      );

      print('✅ Photos response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _photos = data.map((json) => Photo.fromJson(json)).toList();
        print('✅ Photos loaded: ${_photos.length}');
        _state = GalleryState.success;
      } else {
        print('❌ Failed with status: ${response.statusCode}');
        _state = GalleryState.failure;
      }
    } catch (e) {
      print('❌ Photos network error: $e');
      _state = GalleryState.failure;
    }

    notifyListeners();
  }
}
