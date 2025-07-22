import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final String _validUsername = 'admin';
  final String _validPassword = 'admin123';

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool login(String username, String password) {
    if (username == _validUsername && password == _validPassword) {
      _isAuthenticated = true;
      _errorMessage = null;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Invalid username or password';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    _errorMessage = null;
    notifyListeners();
  }
}