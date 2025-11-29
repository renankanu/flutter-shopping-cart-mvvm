import 'package:flutter/material.dart';

import '../../data/repositories/home/home_repository.dart';
import '../../domain/models/product.dart';

class HomeViewmodel extends ChangeNotifier {
  final HomeRepository homeRepository;

  HomeViewmodel({required this.homeRepository});

  final _products = <Product>[];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  Future<void> getProducts() async {
    setIsLoading(true);
    try {
      final products = await homeRepository.getProducts();
      _products.addAll(products);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      setIsLoading(false);
    }
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
