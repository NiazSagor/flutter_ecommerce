import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/data/repositories/auth/auth_repository.dart';

import '../../../../utils/result.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  bool _isLoading = false;

  bool get isLoggedIn => _authRepository.isAuthenticated;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  /// Returns [true] if successful so the View can handle navigation.
  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    final result = await _authRepository.login(
      username: username,
      password: password,
    );

    _setLoading(false);

    switch (result) {
      case Ok():
        return true;
      case Error(error: final e):
        _errorMessage = e.toString();
        notifyListeners();
        return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    await _authRepository.logout();
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
