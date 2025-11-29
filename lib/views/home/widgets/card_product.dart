import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../domain/models/product.dart';
import '../../../shared/shared.dart';

class CardProduct extends StatelessWidget {
  const CardProduct({
    super.key,
    required this.product,
    required this.quantity,
    this.onAdd,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
    this.showAddButton = true,
  });

  final Product product;
  final int quantity;
  final VoidCallback? onAdd;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
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
                  if (quantity > 0)
                    AppQuantityCounter(
                      quantity: quantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    )
                  else if (showAddButton && onAdd != null)
                    AppButton(
                      onPressed: onAdd!,
                      title: 'Adicionar ao carrinho',
                    )
                  else
                    SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
