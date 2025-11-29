import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../data/repositories/cart/cart_repository.dart';
import '../../data/repositories/checkout/checkout_repository.dart';
import '../../domain/models/cart.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/models/product.dart';
import '../../domain/usecases/usecases.dart';

class CartStoreViewmodel extends ChangeNotifier {
  final CartRepository _cartRepository;
  final CheckoutRepository _checkoutRepository;
  final AddItemToCartUseCase _addItemUseCase;
  final UpdateItemQuantityUseCase _updateQuantityUseCase;

  CartStoreViewmodel({
    required CartRepository cartRepository,
    required CheckoutRepository checkoutRepository,
    required AddItemToCartUseCase addItemUseCase,
    required UpdateItemQuantityUseCase updateQuantityUseCase,
  })  : _cartRepository = cartRepository,
        _checkoutRepository = checkoutRepository,
        _addItemUseCase = addItemUseCase,
        _updateQuantityUseCase = updateQuantityUseCase;

  Cart _cart = Cart.empty();
  bool _isLoading = false;
  bool _isRemoving = false;
  String? _errorMessage;

  Cart get cart => _cart;
  bool get isLoading => _isLoading;
  bool get isRemoving => _isRemoving;
  String? get errorMessage => _errorMessage;

  void setErrorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  void addItem(Product product) {
    final result = _addItemUseCase.execute(_cart, product);
    switch (result) {
      case Ok():
        _cart = result.value;
        notifyListeners();
      case Error():
        if (result.error is CartException) {
          _errorMessage = (result.error as CartException).message;
        } else {
          _errorMessage = result.error.toString();
        }
        notifyListeners();
    }
  }

  void incrementItem(Product product) {
    final result = _updateQuantityUseCase.increment(_cart, product);
    switch (result) {
      case Ok():
        _cart = result.value;
        notifyListeners();
      case Error():
        break;
    }
  }

  void decrementItem(Product product) {
    final result = _updateQuantityUseCase.decrement(_cart, product);
    switch (result) {
      case Ok():
        _cart = result.value;
        notifyListeners();
      case Error():
        break;
    }
  }

  Future<void> removeItem(Product product) async {
    setIsRemoving(true);
    final result = await _cartRepository.removeItem(product);
    switch (result) {
      case Ok():
        final newItems = _cart.items
            .where((item) => item.product.id != product.id)
            .toList();
        _cart = _cart.copyWith(items: newItems);
        notifyListeners();
        break;
      case Error():
        if (result.error is CartException) {
          setErrorMessage((result.error as CartException).message);
        } else {
          setErrorMessage(result.error.toString());
        }
        break;
    }
    setIsRemoving(false);
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
    final result = await _checkoutRepository.finalizePurchase();
    switch (result) {
      case Ok():
        setIsLoading(false);
        return result.value;
      case Error():
        setErrorMessage(result.error.toString());
        setIsLoading(false);
        return false;
    }
  }
}
