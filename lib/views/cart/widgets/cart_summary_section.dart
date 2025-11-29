import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../shared/shared.dart';
import '../../../viewmodels/cart/cart_store_viewmodel.dart';

class CartSummarySection extends StatelessWidget {
  const CartSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartStoreViewmodel>(
      builder: (context, model, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              AppSummaryItem(
                title: 'Subtotal',
                value: model.cart.subtotal.toCurrencyBr,
              ),
              AppSummaryItem(
                title: 'Frete',
                value: model.cart.shipping.toCurrencyBr,
              ),
              AppSummaryItem(
                title: 'Total',
                value: model.cart.total.toCurrencyBr,
              ),
              const SizedBox(height: 16),
              AppButton(
                onPressed: () async {
                  final isSuccess = await model.finalizePurchase();
                  if (isSuccess && context.mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      AppConstants.orderRoute,
                      arguments: model.cart,
                    );
                  }
                },
                title: 'Finalizar compra',
                isLoading: model.isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
