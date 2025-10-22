import 'package:flutter/material.dart';
import 'package:baqalty/features/orders/presentation/view/replacement_orders_screen.dart';

/// Example usage of ReplacementOrdersScreen
/// This file shows how to navigate to the replacement orders screen
class ReplacementOrdersExample extends StatelessWidget {
  const ReplacementOrdersExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Replacement Orders Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to replacement orders screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ReplacementOrdersScreen(),
              ),
            );
          },
          child: const Text('View Replacement Orders'),
        ),
      ),
    );
  }
}
