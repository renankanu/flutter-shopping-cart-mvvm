import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/views/home/widgets/card_product.dart';

import '../../core/core.dart';
import '../../shared/widgets/app_loading.dart';
import '../../viewmodels/cart/cart_store_viewmodel.dart';
import 'widgets/cart_summary_section.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late CartStoreViewmodel _cartStoreViewmodel;

  @override
  void initState() {
    super.initState();
    _cartStoreViewmodel = context.read<CartStoreViewmodel>();

    _cartStoreViewmodel.addListener(_handleCartStoreChange);
  }

  void _handleCartStoreChange() {
    if (!mounted) {
      return;
    }
    if (_cartStoreViewmodel.errorMessage != null) {
      context.showErrorSnackBar(_cartStoreViewmodel.errorMessage!);
      _cartStoreViewmodel.clearError();
    }
  }

  @override
  void dispose() {
    _cartStoreViewmodel.removeListener(_handleCartStoreChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho de compras')),
      body: Consumer<CartStoreViewmodel>(
        builder: (context, model, child) {
          final items = model.cart.items;
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final product = item.product;
                        return CardProduct(
                          product: product,
                          quantity: item.quantity,
                          showAddButton: false,
                          onIncrement: () => model.incrementItem(product),
                          onDecrement: () => model.decrementItem(product),
                          onRemove: () async {
                            await model.removeItem(product);
                          },
                        );
                      },
                    ),
                  ),
                  CartSummarySection(),
                ],
              ),
              if (model.isRemoving) AppLoading(message: 'removendo item...'),
            ],
          );
        },
      ),
    );
  }
}
