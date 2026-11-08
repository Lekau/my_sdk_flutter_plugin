import 'package:flutter/material.dart';
import 'package:my_sdk_flutter_plugin/models/cart_model.dart';
import 'package:my_sdk_flutter_plugin/models/item_model.dart';

class ItemListTile extends StatelessWidget {
  final Item item;
  final Cart cart;

  const ItemListTile({super.key, required this.item, required this.cart});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('R${item.price.toStringAsFixed(2)}'),
      trailing:  ListenableBuilder(
        listenable: cart,
        builder: (context, _) {
          final itemCount = cart.items
              .where((i) => i.name == item.name)
              .length;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (itemCount > 0) ...[
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  cart.removeItem(item);
                },
              ),
              ],
              Text('$itemCount'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  cart.addItem(item);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
