import 'dart:convert';
import 'package:flutter_ecommerce/utils/result.dart';
import 'package:http/http.dart' as _httpClient;
import 'api_endpoints.dart';
import 'api_exception.dart';
import 'model/auth/auth_dto.dart';
import 'model/user/user_dto.dart';

class AuthApiService extends BaseApiService {
  AuthApiService(super.httpClient);

  Future<Result<AuthDto>> login(String username, String password) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.login}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        return Result.ok(AuthDto.fromJson(jsonDecode(response.body)));
      }
      return Result.error(ApiException(statusCode: response.statusCode, message: 'Login Failed'));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<UserDto>> getUser(int id) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.userById(id)}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Result.ok(UserDto.fromJson(jsonDecode(response.body)));
      }
      return Result.error(ApiException(statusCode: response.statusCode, message: 'User Fetch Error'));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
