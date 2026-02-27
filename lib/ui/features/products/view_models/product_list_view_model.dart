import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/data/repositories/product/product_repository.dart';

import '../../../../domain/models/product.dart';
import '../../../../utils/result.dart';

class ProductListViewModel extends ChangeNotifier {
  ProductListViewModel({required ProductRepository productRepository})
    : _productRepository = productRepository;

  final Map<String, List<Product>> _categoryProducts = {};
  final Map<String, bool> _loadingStates = {};

  List<Product> getProducts(String category) => _categoryProducts[category] ?? [];
  bool isLoading(String category) => _loadingStates[category] ?? false;

  final ProductRepository _productRepository;

  List<String> _categories = ['all'];

  List<String> get categories => _categories;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<void> init() async {
    await Future.wait([_fetchCategories()]);
  }

  Future<void> refresh(String category) async {
    _categoryProducts.remove(category);
    _errorMessage = null;
    await fetchByCategory(category);
  }

  Future<void> fetchByCategory(String category) async {
    if (_categoryProducts.containsKey(category)) return;

    _loadingStates[category] = true;
    notifyListeners();

    final result = category == 'all'
        ? await _productRepository.getAllProducts()
        : await _productRepository.getProductsByCategory(category);

    switch (result) {
      case Ok(value: final data):
        _categoryProducts[category] = data;
        _errorMessage = null;
      case Error(error: final e):
        _errorMessage = e.toString();
    }

    _loadingStates[category] = false;
    notifyListeners();
  }

  Future<void> _fetchCategories() async {
    final result = await _productRepository.getCategories();
    if (result is Ok<List<String>>) {
      _categories = ['all', ...result.value];
      notifyListeners();
    }
  }
}
