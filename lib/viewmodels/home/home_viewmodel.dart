import 'package:flutter/material.dart';

import '../../data/repositories/home/home_repository.dart';
import '../../domain/models/product.dart';

class HomeViewmodel extends ChangeNotifier {
  final HomeRepository homeRepository;

  HomeViewmodel({required this.homeRepository});

  final _products = <Product>[];

  List<Product> get products => _products;

  Future<void> getProducts() async {
    final products = await homeRepository.getProducts();
    _products.addAll(products);
    notifyListeners();
  }
}
