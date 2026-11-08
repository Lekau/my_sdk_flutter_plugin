import 'package:flutter/material.dart';
import 'package:my_sdk_flutter_plugin/models/cart_model.dart';
import 'package:my_sdk_flutter_plugin/models/item_model.dart';

class CheckoutListTile extends StatelessWidget {
  final Cart cart;
  final Item item;

  const CheckoutListTile({super.key, required this.item, required this.cart});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('R${item.price.toStringAsFixed(2)}'),
      trailing: ListenableBuilder(
        listenable: cart,
        builder: (context, _) {
          final itemCount = cart.items.where((i) => i.name == item.name).length;
          return IconButton(
            onPressed: itemCount > 0 ? () => cart.removeItem(item) : null,
            icon: Icon(Icons.delete),
          );
        },
      ),
    );
  }
}
