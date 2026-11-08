import 'package:flutter/material.dart';
import 'package:my_sdk_flutter_plugin/data/demo_data.dart';
import 'package:my_sdk_flutter_plugin/models/cart_model.dart';
import 'package:my_sdk_flutter_plugin/permissions.dart';
import 'package:my_sdk_flutter_plugin/presentation/components/item_list_tile.dart';
import 'package:my_sdk_flutter_plugin/presentation/screens/checkout/checkout_screen.dart';

class ItemsScreen extends StatefulWidget {
  final Cart cart;

  const ItemsScreen({super.key, required this.cart});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  Cart get cart => widget.cart;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkPermissions());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('New Transaction'), centerTitle: true),
        body: Center(
          child: ListView.builder(
            itemCount: demoStock.length,
            itemBuilder: (context, index) {
              final item = demoStock[index];
              return ItemListTile(item: item, cart: cart);
            },
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListenableBuilder(
            listenable: cart,
            builder: (context, _) {
              return ElevatedButton(
                onPressed: () {
                  if (cart.items.isEmpty) {
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(cart: cart),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    cart.items.isEmpty ? Colors.grey : Colors.yellow,
                  ),
                ),
                child: Text(
                  'Checkout (R${cart.total.toStringAsFixed(2)})',
                  style: TextStyle(
                    color: cart.items.isEmpty ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
