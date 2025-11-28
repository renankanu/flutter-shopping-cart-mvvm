import 'package:shopping_cart/domain/models/cart_item.dart';

class Cart {
  final List<CartItem> items;

  Cart({required this.items});

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  int get totalDifferentItems => items.length;

  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);

  double get shipping => 10;

  double get total => subtotal + shipping;

  factory Cart.empty() => Cart(items: []);
}
