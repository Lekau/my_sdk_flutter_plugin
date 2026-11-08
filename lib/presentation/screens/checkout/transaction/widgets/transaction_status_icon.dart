import 'package:flutter/material.dart';
import 'package:my_sdk_flutter_plugin/presentation/screens/checkout/transaction/transaction_phase.dart';

class TransactionStatusIcon extends StatelessWidget {
  final TransactionPhase phase;

  const TransactionStatusIcon({super.key, required this.phase});

  @override
  Widget build(BuildContext context) {
    switch (phase) {
      case TransactionPhase.starting:
        return const SizedBox(
          width: 96,
          height: 96,
          child: CircularProgressIndicator(),
        );
      case TransactionPhase.inProgress:
        return const Icon(Icons.contactless, size: 120);
      case TransactionPhase.approved:
        return const Icon(Icons.check_circle, size: 120, color: Colors.green);
      case TransactionPhase.failed:
        return const Icon(Icons.error, size: 120, color: Colors.red);
    }
  }
}
