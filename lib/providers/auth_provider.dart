import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;

  void login(String username, String password) {
    if (username.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      _username = username;
    } else {
      _isLoggedIn = false;
      _username = null;
    }

    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _username = null;
    notifyListeners();
  }
}