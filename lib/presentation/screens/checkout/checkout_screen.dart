import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halo_sdk_flutter_plugin/sdkflutterplugin.dart';
import 'package:my_sdk_flutter_plugin/halo_sdk.dart';
import 'package:my_sdk_flutter_plugin/models/cart_model.dart';
import 'package:my_sdk_flutter_plugin/presentation/components/checkout_list_tile.dart';
import 'package:my_sdk_flutter_plugin/presentation/screens/checkout/transaction_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final Cart cart;
  const CheckoutScreen({super.key, required this.cart});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // The SDK only needs initialising once per app session; this blocks repeat
  // calls while a result is pending or after it has succeeded.
  static bool _initRequested = false;

  Cart get cart => widget.cart;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => onInitializeSdk());
  }

  Future<void> onInitializeSdk() async {
    final haloCallbacks = HaloCallbacks.instance;
    if (haloCallbacks.isReady) return;
    if (_initRequested && haloCallbacks.initResult.value == null) return;
    _initRequested = true;

    String package = "za.co.synthesis.halo.sdkflutterplugin_example";
    String appVersion = "0.0.2";
    int onStartTransactionTimeOut = 300000;

    try {
      await Sdkflutterplugin.initializeHaloSDK(
        haloCallbacks,
        package,
        appVersion,
        onStartTransactionTimeOut,
        false,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("SDK initialized successfully")),
      );
    } on PlatformException catch (e) {
      _initRequested = false;
      if (!mounted) return;
      String message = "SDK initialisation error: ${e.code} ${e.message}";
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  String _initStatusText() {
    final type = HaloCallbacks.instance.initResult.value?.resultType;
    if (type == null) return 'Preparing card reader...';
    return 'Card reader unavailable (${type.name})';
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingController discountController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return CheckoutListTile(item: item, cart: cart);
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
            listenable: Listenable.merge([
              cart,
              HaloCallbacks.instance.initResult,
            ]),
            builder: (context, _) {
              final sdkReady = HaloCallbacks.instance.isReady;
              final canPay = cart.items.isNotEmpty && sdkReady;
              return ElevatedButton(
                onPressed: canPay
                    ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionScreen(cart: cart),
                        ),
                      )
                    : null,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    canPay ? Colors.yellow : Colors.grey,
                  ),
                ),
                child: Text(
                  sdkReady
                      ? 'Pay R${cart.total.toStringAsFixed(2)}'
                      : _initStatusText(),
                  style: TextStyle(
                    color: canPay ? Colors.black : Colors.white,
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
