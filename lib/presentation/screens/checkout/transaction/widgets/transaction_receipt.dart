import 'package:flutter/material.dart';
import 'package:halo_sdk_flutter_plugin/model/halo_transaction_result.dart';

class TransactionReceipt extends StatelessWidget {
  final HaloTransactionResult? result;

  const TransactionReceipt({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final receipt = result?.receipt;
    if (receipt == null) return const SizedBox.shrink();
    final reference = result?.merchantTransactionReference;
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        children: [
          Text('Card: ${receipt.maskedPAN}'),
          Text('Auth code: ${receipt.authorizationCode}'),
          if (reference != null) Text('Ref: $reference'),
        ],
      ),
    );
  }
}
