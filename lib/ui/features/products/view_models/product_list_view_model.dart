import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/data/repositories/product/product_repository.dart';

import '../../../../domain/models/product.dart';
import '../../../../utils/result.dart';

class ProductListViewModel extends ChangeNotifier {
  ProductListViewModel({required ProductRepository productRepository})
    : _productRepository = productRepository;

  final ProductRepository _productRepository;

  List<Product> _products = [];

  List<Product> get products => _products;

  List<String> _categories = ['all'];

  List<String> get categories => _categories;

  String _selectedCategory = 'all';

  String get selectedCategory => _selectedCategory;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<void> init() async {
    await Future.wait([_fetchCategories(), loadProducts()]);
  }

  Future<void> refresh() async {
    _productRepository.clearCache();
    _errorMessage = null;
    await loadProducts(forceRefresh: true);
  }

  /// Fetches products, optionally filtered by the current selected category.
  Future<void> loadProducts({bool forceRefresh = false}) async {

    // If not a pull-to-refresh, show our internal loading state
    if (!forceRefresh) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    final result = await _productRepository.getProducts(
      category: _selectedCategory == 'all' ? null : _selectedCategory,
    );

    switch (result) {
      case Ok(value: final data):
        _products = data;
        _errorMessage = null;
      case Error(error: final e):
        _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Updates the selected category and triggers a new product fetch.
  Future<void> updateCategory(String category) async {
    if (_selectedCategory == category) return;

    _selectedCategory = category;
    notifyListeners();
    await loadProducts();
  }

  Future<void> _fetchCategories() async {
    final result = await _productRepository.getCategories();
    if (result is Ok<List<String>>) {
      _categories = ['all', ...result.value];
      notifyListeners();
    }
  }
}
