import 'package:flutter_ecommerce/data/repositories/mappers/product_mapper.dart';
import 'package:flutter_ecommerce/data/repositories/product/product_repository.dart';
import 'package:flutter_ecommerce/data/services/api/model/product/produdct_dto.dart';
import 'package:flutter_ecommerce/data/services/api/product_api_service.dart';
import 'package:flutter_ecommerce/domain/models/product.dart';
import 'package:flutter_ecommerce/utils/result.dart';

class ProductRepositoryRemote implements ProductRepository {
  ProductRepositoryRemote({required ProductApiService apiService})
    : _apiService = apiService;

  final ProductApiService _apiService;

  // Cache storage
  final Map<String, List<Product>> _categoryCache = {};
  List<String>? _cachedCategories;

  @override
  Future<Result<List<Product>>> getProducts({String? category}) async {
    final key = category ?? 'all';

    if (_categoryCache.containsKey(key)) {
      return Result.ok(_categoryCache[key]!);
    }

    final result = await _apiService.getProductsByCategory(key);

    if (result is Ok<List<ProductDto>>) {
      final products = result.value
          .map((dto) => ProductMapper.toDomain(dto))
          .toList();
      _categoryCache[key] = products;
      return Result.ok(products);
    }
    return Result.error((result as Error).error);
  }

  @override
  Future<Result<List<String>>> getCategories() async {
    if (_cachedCategories != null) return Result.ok(_cachedCategories!);

    final result = await _apiService.getCategories();
    if (result is Ok<List<String>>) {
      _cachedCategories = result.value;
    }
    return result;
  }
}
