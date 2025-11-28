import 'package:flutter/material.dart';

import '../../../viewmodels/cart/cart_store_viewmodel.dart';

class BadgeCounter extends StatelessWidget {
  const BadgeCounter({super.key, required this.model});

  final CartStoreViewmodel model;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Stack(
        children: [
          Center(child: Icon(Icons.shopping_cart)),
          if (model.cart.totalItems > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  model.cart.totalItems.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
