import 'package:flutter_ecommerce/data/repositories/auth/auth_repository.dart';
import 'package:flutter_ecommerce/data/services/api/auth_api_client.dart';
import 'package:flutter_ecommerce/data/services/api/model/login_request/login_request.dart';
import 'package:flutter_ecommerce/data/services/api/product_api_service.dart';
import 'package:flutter_ecommerce/utils/result.dart';

class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote({
    required AuthApiService authApiService,
    required ProductApiService productApiService,
  }) : _authApiService = authApiService,
       _productApiService = productApiService;

  final AuthApiService _authApiService;
  final ProductApiService _productApiService;

  bool? _isAuthenticated;
  String? _authToken;

  @override
  Future<bool> get isAuthenticated async {
    return _isAuthenticated ?? false;
  }

  @override
  Future<Result<void>> login({
    required String username,
    required String password,
  }) async {
    try {
      final result = await _authApiService.login(
        LoginRequest(username: username, password: password)
      );

      switch (result) {
        case Ok(value: final authDto):
          _authToken = authDto.token;
          _isAuthenticated = true;
          _authApiService.setToken(_authToken!);
          _productApiService.setToken(_authToken!);

          return const Result.ok(null);

        case Error(error: final e):
          return Result.error(e);
      }
    } finally {}
  }

  @override
  Future<Result<void>> logout() async {
    try {
      _authToken = null;
      _isAuthenticated = false;
      _authApiService.clearToken();
      _productApiService.clearToken();

      return const Result.ok(null);
    } finally {}
  }
}
