import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/product.dart';
import '../../viewmodels/cart/cart_store_viewmodel.dart';

class AppQuantityCounter extends StatelessWidget {
  const AppQuantityCounter({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CartStoreViewmodel>();
    return Row(
      children: [
        IconButton(
          onPressed: () => model.decrementItem(product),
          icon: Icon(Icons.remove),
        ),
        Text(model.getItemQuantity(product).toString()),
        IconButton(
          onPressed: () => model.incrementItem(product),
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
