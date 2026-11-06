import 'package:shopping_cart/domain/models/cart.dart';
import 'package:shopping_cart/domain/models/cart_item.dart';
import 'package:shopping_cart/domain/models/product.dart';
import 'package:shopping_cart/domain/models/rating.dart';

Product makeProduct({
  int id = 1,
  String title = 'Product 1',
  double price = 10.0,
}) {
  return Product(
    id: id,
    title: title,
    price: price,
    description: 'Description $id',
    category: 'Category',
    image: 'https://example.com/image$id.jpg',
    rating: Rating(rate: 4.5, count: 100),
  );
}

Cart makeCartWithProducts(int count, {int quantity = 1}) {
  return Cart(
    items: [
      for (var i = 1; i <= count; i++)
        CartItem(
          product: makeProduct(id: i, title: 'Product $i', price: i * 10.0),
          quantity: quantity,
        ),
    ],
  );
}
