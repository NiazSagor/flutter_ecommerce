import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/data/repositories/user/user_repository.dart';

import '../../../../domain/models/user.dart';
import '../../../../utils/result.dart';

class UserViewModel extends ChangeNotifier {
  UserViewModel({required UserRepository userRepository})
    : _userRepository = userRepository;

  final UserRepository _userRepository;

  User? _user;

  User? get user => _user;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<void> loadUser(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _userRepository.getUser(userId);

    switch (result) {
      case Ok(value: final userData):
        _user = userData;
        _errorMessage = null;
      case Error(error: final e):
        _errorMessage = e.toString();
        _user = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }
}
