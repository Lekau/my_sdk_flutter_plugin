import 'package:flutter/material.dart';
import 'package:my_sdk_flutter_plugin/models/cart_model.dart';
import 'package:my_sdk_flutter_plugin/presentation/screens/items/items_screen.dart';

class ShopFlow extends StatefulWidget {
  const ShopFlow({super.key});

  @override
  State<ShopFlow> createState() => _ShopFlowState();
}

class _ShopFlowState extends State<ShopFlow> {
  late final Cart cart = Cart();

  @override
  void dispose() {
    cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ItemsScreen(cart: cart);
  }
}