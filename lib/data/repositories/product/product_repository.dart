import 'package:flutter_ecommerce/domain/models/product.dart';
import 'package:flutter_ecommerce/utils/result.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> getProductsByCategory(String category);

  Future<Result<List<Product>>> getAllProducts();

  Future<Result<List<String>>> getCategories();

  void clearCache();
}
