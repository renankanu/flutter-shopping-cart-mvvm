import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../domain/models/cart.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/models/product.dart';

class CartStoreViewmodel extends ChangeNotifier {
  final _cart = Cart.empty();

  Cart get cart => _cart;

  void addItem(Product product) {
    if (_cart.totalDifferentItems >= AppConstants.maxItems) {
      throw Exception(
        'Limite de ${AppConstants.maxItems} produtos diferentes atingido.'
        ' Remova alguns produtos para adicionar mais.',
      );
    }
    final existingIndex = _cart.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      _cart.items[existingIndex] = _cart.items[existingIndex].copyWith(
        quantity: _cart.items[existingIndex].quantity + 1,
      );
    } else {
      _cart.items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void incrementItem(Product product) {
    final existingIndex = _cart.items.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (existingIndex >= 0) {
      _cart.items[existingIndex] = _cart.items[existingIndex].copyWith(
        quantity: _cart.items[existingIndex].quantity + 1,
      );
    }
    notifyListeners();
  }

  void decrementItem(Product product) {
    final existingIndex = _cart.items.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (existingIndex >= 0) {
      _cart.items[existingIndex] = _cart.items[existingIndex].copyWith(
        quantity: _cart.items[existingIndex].quantity - 1,
      );
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    _cart.items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void clear() {
    _cart.items.clear();
    notifyListeners();
  }

  int getItemQuantity(Product product) {
    final item = _cart.items.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    return item.quantity;
  }
}
