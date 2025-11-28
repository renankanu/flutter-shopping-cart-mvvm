import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../data/repositories/cart/cart_repository.dart';
import '../../data/repositories/checkout/checkout_repository.dart';
import '../../domain/models/cart.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/models/product.dart';

class CartStoreViewmodel extends ChangeNotifier {
  final CartRepository _cartRepository;
  final CheckoutRepository _checkoutRepository;

  CartStoreViewmodel({
    required CartRepository cartRepository,
    required CheckoutRepository checkoutRepository,
  }) : _cartRepository = cartRepository,
       _checkoutRepository = checkoutRepository;

  final _cart = Cart.empty();
  bool _isLoading = false;
  bool _isRemoving = false;
  String? _errorMessage;

  Cart get cart => _cart;
  bool get isLoading => _isLoading;
  bool get isRemoving => _isRemoving;
  String? get errorMessage => _errorMessage;

  set errorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  void addItem(Product product) {
    if (_cart.totalDifferentItems >= AppConstants.maxItems) {
      _errorMessage =
          'Limite de ${AppConstants.maxItems} produtos '
          'diferentes atingido. Remova alguns produtos '
          'para adicionar mais.';
      notifyListeners();
      return;
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

  Future<void> removeItem(Product product) async {
    setIsRemoving(true);
    try {
      await _cartRepository.removeItem(product);
      _cart.items.removeWhere((item) => item.product.id == product.id);
      notifyListeners();
    } on CartException catch (e) {
      errorMessage = e.message;
    } finally {
      setIsRemoving(false);
    }
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

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setIsRemoving(bool value) {
    _isRemoving = value;
    notifyListeners();
  }

  Future<bool> finalizePurchase() async {
    setIsLoading(true);
    bool isSuccess = false;
    try {
      await _checkoutRepository.finalizePurchase();
      isSuccess = true;
    } catch (e) {
      errorMessage = e.toString();
      isSuccess = false;
    } finally {
      setIsLoading(false);
    }
    return isSuccess;
  }
}
