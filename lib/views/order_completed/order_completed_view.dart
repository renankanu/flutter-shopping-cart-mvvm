import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/cart.dart';
import '../../viewmodels/cart/cart_store_viewmodel.dart';
import 'widgets/item_order.dart';
import 'widgets/order_completed_summary.dart';

class OrderCompletedView extends StatelessWidget {
  const OrderCompletedView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = ModalRoute.of(context)?.settings.arguments as Cart;

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          context.read<CartStoreViewmodel>().clear();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Compra finalizada')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    return ItemOrder(cartItem: cart.items[index]);
                  },
                ),
              ),
              OrderCompletedSummary(cart: cart),
            ],
          ),
        ),
      ),
    );
  }
}
