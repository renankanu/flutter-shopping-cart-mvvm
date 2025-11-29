import 'package:flutter/material.dart';

class AppQuantityCounter extends StatelessWidget {
  const AppQuantityCounter({
    super.key,
    required this.quantity,
    this.onIncrement,
    this.onDecrement,
  });

  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onDecrement,
          icon: Icon(Icons.remove),
        ),
        Text(quantity.toString()),
        IconButton(
          onPressed: onIncrement,
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
