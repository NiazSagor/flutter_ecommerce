import 'dart:convert';
import 'package:http/http.dart' as _httpClient;
import '../../../utils/result.dart';
import 'api_endpoints.dart';
import 'api_exception.dart';
import 'model/product/produdct_dto.dart';

class ProductApiService extends BaseApiService {
  ProductApiService(super.httpClient);

  Future<Result<List<ProductDto>>> getAllProducts() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.products}'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return Result.ok(
          data.map((json) => ProductDto.fromJson(json)).toList(),
        );
      }
      return Result.error(
        ApiException(statusCode: response.statusCode, message: 'Load Error'),
      );
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<ProductDto>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final response = await _httpClient.get(
        Uri.parse(
          '${ApiEndpoints.baseUrl}${ApiEndpoints.productsByCategory(category)}',
        ),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return Result.ok(
          data.map((json) => ProductDto.fromJson(json)).toList(),
        );
      }
      return Result.error(
        ApiException(
          statusCode: response.statusCode,
          message: 'Category Load Error',
        ),
      );
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<String>>> getCategories() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.categories}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return Result.ok(List<String>.from(data));
      }

      return Result.error(
        ApiException(
          statusCode: response.statusCode,
          message: 'Failed to fetch categories',
        ),
      );
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
