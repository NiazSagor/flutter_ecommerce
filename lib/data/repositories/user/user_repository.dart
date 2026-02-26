import 'package:flutter_ecommerce/domain/models/user.dart';
import 'package:flutter_ecommerce/utils/result.dart';

/// Data source for user related data
abstract class UserRepository {
  /// Get current user
  Future<Result<User>> getUser(int id);
}
