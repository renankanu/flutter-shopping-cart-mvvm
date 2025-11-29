import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../domain/models/cart.dart';
import '../../../shared/shared.dart';
import '../../../viewmodels/cart/cart_store_viewmodel.dart';

class OrderCompletedSummary extends StatelessWidget {
  const OrderCompletedSummary({super.key, required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        AppSummaryItem(
          title: 'Subtotal',
          value: cart.subtotal.toCurrencyBr,
        ),
        AppSummaryItem(
          title: 'Frete',
          value: cart.shipping.toCurrencyBr,
        ),
        AppSummaryItem(
          title: 'Total',
          value: cart.total.toCurrencyBr,
        ),
        const SizedBox(height: 16),
        AppButton(
          onPressed: () {
            context.read<CartStoreViewmodel>().clear();
            Navigator.pop(context);
          },
          title: 'Novo pedido',
        ),
      ],
    );
  }
}
