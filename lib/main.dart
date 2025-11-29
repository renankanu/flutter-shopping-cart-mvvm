import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/views/home/home_view.dart';

import 'core/core.dart';
import 'data/repositories/cart/cart_repository.dart';
import 'data/repositories/cart/cart_repository_impl.dart';
import 'data/repositories/checkout/checkout_repository.dart';
import 'data/repositories/checkout/checkout_repository_impl.dart';
import 'data/repositories/home/home_repository.dart';
import 'data/repositories/home/home_repository_impl.dart';
import 'domain/usecases/usecases.dart';
import 'viewmodels/cart/cart_store_viewmodel.dart';
import 'viewmodels/home/home_viewmodel.dart';
import 'views/cart/cart_view.dart';
import 'views/order_completed/order_completed_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Dio>(
          create: (_) => DioClient.client,
        ),
        Provider<HomeRepository>(
          create: (context) => HomeRepositoryImpl(dio: context.read<Dio>()),
        ),
        Provider<CartRepository>(
          create: (context) => CartRepositoryImpl(),
        ),
        Provider<CheckoutRepository>(
          create: (context) => CheckoutRepositoryImpl(dio: context.read<Dio>()),
        ),
        Provider(
          create: (_) => AddItemToCartUseCase(),
        ),
        Provider(
          create: (_) => UpdateItemQuantityUseCase(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewmodel(
            homeRepository: context.read<HomeRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CartStoreViewmodel(
            cartRepository: context.read<CartRepository>(),
            checkoutRepository: context.read<CheckoutRepository>(),
            addItemUseCase: context.read<AddItemToCartUseCase>(),
            updateQuantityUseCase: context.read<UpdateItemQuantityUseCase>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Shopping Cart',
        theme: AppTheme.theme,
        initialRoute: AppConstants.homeRoute,
        routes: {
          AppConstants.homeRoute: (_) => const HomeView(),
          AppConstants.cartRoute: (_) => const CartView(),
          AppConstants.orderRoute: (_) => const OrderCompletedView(),
        },
      ),
    );
  }
}
