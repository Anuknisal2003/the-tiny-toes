import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';

enum UsersState { loading, success, failure }

class UsersProvider with ChangeNotifier {
  List<User> _users = [];
  UsersState _state = UsersState.loading;

  List<User> get users => _users;
  UsersState get state => _state;

  Future<void> fetchUsers() async {
    _state = UsersState.loading;
    notifyListeners();

    final url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    print('➡️ Sending GET request to: $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'tinytoes-flutter-app/1.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)',
        },
      );

      print('✅ Response status: ${response.statusCode}');
      print('✅ Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _users = data.map((json) => User.fromJson(json)).toList();
        print('✅ Users loaded: ${_users.length}');
        _state = UsersState.success;
      } else {
        print('❌ Status not 200: ${response.statusCode}');
        _state = UsersState.failure;
      }
    } catch (e) {
      print('❌ Network error: $e');
      _state = UsersState.failure;
    }

    notifyListeners();
  }
}
