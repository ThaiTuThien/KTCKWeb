import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Category> _categories = [];
  Product? productDetail;
  bool _isLoading = false;
  String? _error;
  int _offset = 0;
  final int _limit = 10;
  bool _hasMore = true; // Kiểm tra xem còn dữ liệu để tải thêm không

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  final ApiService _apiService = ApiService();

  Future<void> fetchProducts({bool isLoadMore = false}) async {
    if (_isLoading || (!_hasMore && isLoadMore)) return;

    _isLoading = true;
    if (!isLoadMore) _offset = 0; 
    notifyListeners();

    try {
      final newProducts = await _apiService.getProducts(offset: _offset, limit: _limit);
      if (isLoadMore) {
        _products.addAll(newProducts);
      } else {
        _products = newProducts;
      }
      _error = null;
      _offset += _limit;
      _hasMore = newProducts.length == _limit; 
    } catch (e) {
      _error = e.toString();
      _hasMore = false; 
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _apiService.getCategories();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProductDetail(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      productDetail = await _apiService.getProductDetail(id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createProduct(Map<String, dynamic> productData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newProduct = await _apiService.createProduct(productData);
      _products.insert(0, newProduct); 
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProduct(int id, Map<String, dynamic> productData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedProduct = await _apiService.updateProduct(id, productData);
      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        _products[index] = updatedProduct; 
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}