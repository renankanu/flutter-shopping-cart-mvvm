import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../shared/shared.dart';
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
  late HomeViewmodel _homeViewmodel;
  late CartStoreViewmodel _cartStoreViewmodel;

  @override
  void initState() {
    super.initState();
    _homeViewmodel = context.read<HomeViewmodel>();
    _cartStoreViewmodel = context.read<CartStoreViewmodel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeViewmodel.getProducts();
    });

    _homeViewmodel.addListener(_handleHomeViewmodelChange);
    _cartStoreViewmodel.addListener(_handleCartStoreViewmodelChange);
  }

  void _handleHomeViewmodelChange() {
    if (!mounted) {
      return;
    }
    if (_homeViewmodel.errorMessage != null) {
      context.showErrorSnackBar(_homeViewmodel.errorMessage!);
      _homeViewmodel.clearError();
    }
  }

  void _handleCartStoreViewmodelChange() {
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
    _homeViewmodel.removeListener(_handleHomeViewmodelChange);
    _cartStoreViewmodel.removeListener(_handleCartStoreViewmodelChange);
    super.dispose();
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
      body: Consumer<HomeViewmodel>(
        builder: (context, model, child) {
          if (model.isLoading) {
            return const Center(
              child: AppLoading(
                color: Colors.white,
                message: 'Carregando produtos...',
              ),
            );
          }

          if (model.products.isEmpty) {
            return Center(
              child: Text(
                'Nenhum produto disponível',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return Consumer<CartStoreViewmodel>(
            builder: (context, cartModel, _) {
              return ListView.builder(
                itemCount: model.products.length,
                itemBuilder: (context, index) {
                  final product = model.products[index];
                  final quantity = cartModel.getItemQuantity(product);
                  return SizedBox(
                    height: 182,
                    child: CardProduct(
                      product: product,
                      quantity: quantity,
                      onAdd: () => cartModel.addItem(product),
                      onIncrement: () => cartModel.incrementItem(product),
                      onDecrement: () => cartModel.decrementItem(product),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
