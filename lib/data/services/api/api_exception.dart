import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// A base class to handle common HTTP logic and state (like tokens).
abstract class BaseApiService {
  final http.Client _httpClient;
  String? _token;

  BaseApiService(this._httpClient);

  void setToken(String token) => _token = token;

  void clearToken() => _token = null;

  bool get hasToken => _token != null;

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  void assertOk(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
  }
}
