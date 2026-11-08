import 'package:flutter/material.dart';
import 'package:my_sdk_flutter_plugin/presentation/screens/checkout/transaction/transaction_phase.dart';

class TransactionActions extends StatelessWidget {
  final TransactionPhase phase;
  final VoidCallback onCancel;
  final VoidCallback onDone;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  const TransactionActions({
    super.key,
    required this.phase,
    required this.onCancel,
    required this.onDone,
    required this.onBack,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (phase) {
      case TransactionPhase.starting:
      case TransactionPhase.inProgress:
        return OutlinedButton(onPressed: onCancel, child: const Text('Cancel'));
      case TransactionPhase.approved:
        return _PrimaryButton(label: 'Done', onPressed: onDone);
      case TransactionPhase.failed:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onBack,
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _PrimaryButton(label: 'Try again', onPressed: onRetry),
            ),
          ],
        );
    }
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.yellow),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
