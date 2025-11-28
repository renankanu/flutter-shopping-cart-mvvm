import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/views/home/home_view.dart';

import 'core/core.dart';
import 'data/repositories/home/home_repository_impl.dart';
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
        Provider(
          create: (_) => DioClient.client,
        ),
        ChangeNotifierProvider(
          create: (context) => HomeViewmodel(
            homeRepository: HomeRepositoryImpl(
              dio: context.read<Dio>(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Shopping Cart',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
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
