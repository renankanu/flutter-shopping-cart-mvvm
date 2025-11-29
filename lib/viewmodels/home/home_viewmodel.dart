import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../data/repositories/home/home_repository.dart';
import '../../domain/models/product.dart';

class HomeViewmodel extends ChangeNotifier {
  final HomeRepository homeRepository;

  HomeViewmodel({required this.homeRepository});

  final _products = <Product>[];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setErrorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  Future<void> getProducts() async {
    setIsLoading(true);
    final result = await homeRepository.getProducts();
    switch (result) {
      case Ok():
        _products.addAll(result.value);
        break;
      case Error():
        setErrorMessage(result.error.toString());
    }
    setIsLoading(false);
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
