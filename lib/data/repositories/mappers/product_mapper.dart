import 'package:flutter_ecommerce/data/services/api/model/product/produdct_dto.dart';

import '../../../domain/models/product.dart';

abstract class ProductMapper {
  /// Transforms a Data Transfer Object (DTO) into a clean Domain Model.
  static Product toDomain(ProductDto dto) {
    return Product(
      id: dto.id,
      title: dto.title,
      price: dto.price,
      description: dto.description,
      category: dto.category,
      image: dto.image,
      rating: Rating(rate: dto.rating.rate, count: dto.rating.count),
    );
  }
}
