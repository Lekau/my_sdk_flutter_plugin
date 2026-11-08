import 'package:flutter/material.dart';
import 'package:my_sdk_flutter_plugin/models/cart_model.dart';
import 'package:my_sdk_flutter_plugin/presentation/components/checkout_list_tile.dart';


class CheckoutScreen extends StatelessWidget {
  final Cart cart;

  const CheckoutScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    TextEditingController discountController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return CheckoutListTile(
                    item: item,
                    cart: cart,
                  );
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
            //   child: ListenableBuilder(
            //     listenable: cart,
            //     builder: (context, _) {
            //       return Form(
            //         child: Column(
            //           children: [
            //             TextFormField(
            //               controller: discountController,

            //               decoration: InputDecoration(
            //                 labelText: 'Enter amount',
            //                 border: OutlineInputBorder(),
            //               ),
            //               keyboardType: TextInputType.number,
            //             ),
            //             SizedBox(height: 16.0),
            //             Text('Enter the amount of discount to apply, not the total price, for example, enter 50 for a R50 discount.'),
            //             ElevatedButton(
            //               onPressed: () {
            //                 if (cart.items.isEmpty) {
            //                   return;
            //                 }
            //                cart.applyDiscount(double.tryParse(
            //                   discountController.text,
            //                 ) ?? 0);
            //               },
            //               child: Text('Apply Discount'),
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            //   ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
          child: ListenableBuilder(
            listenable: cart,
            builder: (context, _) {
              return ElevatedButton(
                onPressed: () {
                  if (cart.items.isEmpty) {
                    return;
                  }
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    cart.items.isEmpty ? Colors.grey : Colors.yellow,
                  ),
                ),
                child: Text(
                  'Total: R${cart.total.toStringAsFixed(2)}',
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