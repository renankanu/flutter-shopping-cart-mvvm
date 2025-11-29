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

  Cart _cart = Cart.empty();
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

    final List<CartItem> newItems;
    if (existingIndex >= 0) {
      newItems = List.from(_cart.items);
      newItems[existingIndex] = newItems[existingIndex].copyWith(
        quantity: newItems[existingIndex].quantity + 1,
      );
    } else {
      newItems = [..._cart.items, CartItem(product: product, quantity: 1)];
    }

    _cart = _cart.copyWith(items: newItems);
    notifyListeners();
  }

  void incrementItem(Product product) {
    final existingIndex = _cart.items.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (existingIndex >= 0) {
      final newItems = List<CartItem>.from(_cart.items);
      newItems[existingIndex] = newItems[existingIndex].copyWith(
        quantity: newItems[existingIndex].quantity + 1,
      );
      _cart = _cart.copyWith(items: newItems);
    }
    notifyListeners();
  }

  void decrementItem(Product product) {
    final existingIndex = _cart.items.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (existingIndex >= 0) {
      final newItems = List<CartItem>.from(_cart.items);
      newItems[existingIndex] = newItems[existingIndex].copyWith(
        quantity: newItems[existingIndex].quantity - 1,
      );
      _cart = _cart.copyWith(items: newItems);
    }
    notifyListeners();
  }

  Future<void> removeItem(Product product) async {
    setIsRemoving(true);
    try {
      await _cartRepository.removeItem(product);
      final newItems = _cart.items
          .where((item) => item.product.id != product.id)
          .toList();
      _cart = _cart.copyWith(items: newItems);
      notifyListeners();
    } on CartException catch (e) {
      errorMessage = e.message;
    } finally {
      setIsRemoving(false);
    }
  }

  void clear() {
    _cart = Cart.empty();
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

  void clearError() {
    _errorMessage = null;
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
