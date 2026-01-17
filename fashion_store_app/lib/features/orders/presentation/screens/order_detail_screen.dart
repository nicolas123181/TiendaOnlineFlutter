import 'package:flutter/material.dart';

/// Pantalla de detalle del pedido
class OrderDetailScreen extends StatelessWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pedido #$orderId')),
      body: const Center(child: Text('Detalle del pedido - En desarrollo')),
    );
  }
}
