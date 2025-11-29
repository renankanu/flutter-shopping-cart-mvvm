import '../models/cart.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../../core/utils/result.dart';

class UpdateItemQuantityUseCase {
  Result<Cart> increment(Cart cart, Product product) {
    final itemIndex = cart.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (itemIndex < 0) {
      return Result.ok(cart);
    }

    final updatedItems = List<CartItem>.from(cart.items);
    final currentItem = updatedItems[itemIndex];
    updatedItems[itemIndex] = currentItem.copyWith(
      quantity: currentItem.quantity + 1,
    );

    return Result.ok(cart.copyWith(items: updatedItems));
  }

  Result<Cart> decrement(Cart cart, Product product) {
    final itemIndex = cart.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (itemIndex < 0) {
      return Result.ok(cart);
    }

    final currentItem = cart.items[itemIndex];
    final newQuantity = currentItem.quantity - 1;

    if (newQuantity <= 0) {
      final updatedItems = List<CartItem>.from(cart.items)..removeAt(itemIndex);
      return Result.ok(cart.copyWith(items: updatedItems));
    }

    final updatedItems = List<CartItem>.from(cart.items);
    updatedItems[itemIndex] = currentItem.copyWith(quantity: newQuantity);

    return Result.ok(cart.copyWith(items: updatedItems));
  }
}
