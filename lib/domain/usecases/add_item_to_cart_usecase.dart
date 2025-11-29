import '../models/cart.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../../core/app_constants.dart';
import '../../core/exceptions/cart_exception.dart';
import '../../core/utils/result.dart';

class AddItemToCartUseCase {
  Result<Cart> execute(Cart cart, Product product) {
    if (cart.totalDifferentItems >= AppConstants.maxItems) {
      return Result.error(
        CartException(
          message:
              'Limite de ${AppConstants.maxItems} produtos diferentes atingido.',
        ),
      );
    }

    final existingItemIndex = cart.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    final List<CartItem> updatedItems;

    if (existingItemIndex >= 0) {
      updatedItems = List.from(cart.items);
      final currentItem = updatedItems[existingItemIndex];
      updatedItems[existingItemIndex] = currentItem.copyWith(
        quantity: currentItem.quantity + 1,
      );
    } else {
      updatedItems = [...cart.items, CartItem(product: product, quantity: 1)];
    }

    return Result.ok(cart.copyWith(items: updatedItems));
  }
}
