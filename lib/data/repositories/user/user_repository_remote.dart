import 'package:flutter_ecommerce/data/repositories/mappers/user_mapper.dart';
import 'package:flutter_ecommerce/data/repositories/user/user_repository.dart';
import 'package:flutter_ecommerce/data/services/api/auth_api_client.dart';
import 'package:flutter_ecommerce/domain/models/user.dart';
import 'package:flutter_ecommerce/utils/result.dart';

class UserRepositoryRemote implements UserRepository {
  UserRepositoryRemote({required AuthApiService apiService})
    : _apiService = apiService;

  final AuthApiService _apiService;
  User? _cachedData;

  @override
  Future<Result<User>> getUser(int id) async {
    if (_cachedData != null && _cachedData!.id == id) {
      return Result.ok(_cachedData!);
    }
    final result = await _apiService.getUser(id);
    return switch (result) {
      Ok(value: final dto) => () {
        final user = UserMapper.toDomain(dto);
        _cachedData = user;
        return Result.ok(user);
      }(),
      Error(error: final e) => Result.error(e),
    };
  }
}
