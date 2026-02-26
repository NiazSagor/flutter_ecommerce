import 'package:flutter_ecommerce/domain/models/product.dart';
import 'package:flutter_ecommerce/utils/result.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> getProducts({String? category});
  Future<Result<List<String>>> getCategories();
  void clearCache();
}
