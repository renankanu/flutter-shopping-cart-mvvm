import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../viewmodels/cart/cart_store_viewmodel.dart';
import '../../viewmodels/home/home_viewmodel.dart';
import 'widgets/badge_counter.dart';
import 'widgets/card_product.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeViewmodel>().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<CartStoreViewmodel>(
            builder: (context, model, child) {
              return IconButton(
                onPressed: () {
                  if (model.cart.totalItems == 0) {
                    context.showInfoSnackBar(
                      'Adicione produtos ao carrinho para visualizar',
                    );
                    return;
                  }
                  Navigator.pushNamed(
                    context,
                    AppConstants.cartRoute,
                  );
                },
                icon: BadgeCounter(model: model),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          Expanded(
            child: Consumer<HomeViewmodel>(
              builder: (context, model, child) {
                return ListView.builder(
                  itemCount: model.products.length,
                  itemBuilder: (context, index) {
                    final product = model.products[index];
                    return SizedBox(
                      height: 178,
                      child: CardProduct(product: product),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
