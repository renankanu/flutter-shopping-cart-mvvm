import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/product.dart';
import '../../viewmodels/cart/cart_store_viewmodel.dart';

class AppQuantityCounter extends StatelessWidget {
  const AppQuantityCounter({
    super.key,
    required this.product,
    this.onRemove,
  });

  final Product product;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<CartStoreViewmodel>();
    final quantity = model.getItemQuantity(product);
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (quantity == 1 && onRemove != null) {
              onRemove!();
              return;
            }
            model.decrementItem(product);
          },
          icon: Icon(Icons.remove),
        ),
        Text(quantity.toString()),
        IconButton(
          onPressed: () => model.incrementItem(product),
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
