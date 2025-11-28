import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../domain/models/product.dart';
import '../../../shared/shared.dart';
import '../../../viewmodels/cart/cart_store_viewmodel.dart';

class CardProduct extends StatelessWidget {
  const CardProduct({
    super.key,
    required this.product,
    this.onRemove,
    this.showAddButton = true,
  });

  final Product product;
  final VoidCallback? onRemove;
  final bool showAddButton;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            AppImage(
              url: product.image,
              fit: BoxFit.contain,
              height: 120,
              width: 120,
            ),
            SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (onRemove != null)
                        IconButton(
                          onPressed: onRemove,
                          icon: Icon(Icons.delete_outline),
                          color: Colors.red,
                        ),
                    ],
                  ),
                  Text(product.price.toCurrencyBr),
                  Consumer<CartStoreViewmodel>(
                    builder: (context, model, child) {
                      final quantity = model.getItemQuantity(product);
                      if (quantity > 0) {
                        return AppQuantityCounter(
                          product: product,
                          onRemove: onRemove,
                        );
                      }
                      if (showAddButton) {
                        return AppButton(
                          onPressed: () {
                            try {
                              model.addItem(product);
                            } on CartException catch (exception) {
                              context.showErrorSnackBar(exception.message);
                            }
                          },
                          title: 'Adicionar ao carrinho',
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
