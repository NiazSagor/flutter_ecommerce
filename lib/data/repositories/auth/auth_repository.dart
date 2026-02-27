import 'package:flutter_ecommerce/utils/result.dart';

abstract class AuthRepository {
  /// Returns true when the user is logged in
  /// Returns [Future] because it will load a stored auth state the first time.
  bool get isAuthenticated;

  /// Perform login
  Future<Result<void>> login({required String username, required String password});

  /// Perform logout
  Future<Result<void>> logout();
}
