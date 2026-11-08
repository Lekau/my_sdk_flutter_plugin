import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halo_sdk_flutter_plugin/model/halo_start_transaction_result_type.dart';
import 'package:halo_sdk_flutter_plugin/model/halo_transaction_result.dart';
import 'package:halo_sdk_flutter_plugin/model/halo_transaction_result_type.dart';
import 'package:halo_sdk_flutter_plugin/model/halo_ui_message.dart';
import 'package:halo_sdk_flutter_plugin/sdkflutterplugin.dart';
import 'package:my_sdk_flutter_plugin/halo_sdk.dart';
import 'package:my_sdk_flutter_plugin/models/cart_model.dart';
import 'package:my_sdk_flutter_plugin/presentation/screens/checkout/transaction/transaction_messages.dart';
import 'package:my_sdk_flutter_plugin/presentation/screens/checkout/transaction/transaction_phase.dart';
import 'package:my_sdk_flutter_plugin/presentation/screens/checkout/transaction/widgets/transaction_actions.dart';
import 'package:my_sdk_flutter_plugin/presentation/screens/checkout/transaction/widgets/transaction_receipt.dart';
import 'package:my_sdk_flutter_plugin/presentation/screens/checkout/transaction/widgets/transaction_status_icon.dart';

class TransactionScreen extends StatefulWidget {
  final Cart cart;

  const TransactionScreen({super.key, required this.cart});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _sdk = HaloCallbacks.instance;
  StreamSubscription<HaloUIMessage>? _uiSub;
  StreamSubscription<HaloTransactionResult>? _resultSub;

  TransactionPhase _phase = TransactionPhase.starting;
  String _message = 'Starting transaction...';
  HaloTransactionResult? _result;
  late final double _amount = widget.cart.total;

  String get _currency =>
      _sdk.initResult.value?.terminalCurrency?.currencyCode ?? 'ZAR';

  @override
  void initState() {
    super.initState();
    _uiSub = _sdk.uiMessages.listen(_onUiMessage);
    _resultSub = _sdk.transactionResults.listen(_onResult);
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTransaction());
  }

  @override
  void dispose() {
    _uiSub?.cancel();
    _resultSub?.cancel();
    super.dispose();
  }

  Future<void> _startTransaction() async {
    setState(() {
      _phase = TransactionPhase.starting;
      _message = 'Starting transaction...';
      _result = null;
    });

    final reference = 'ORDER-${DateTime.now().millisecondsSinceEpoch}';
    try {
      final start = await Sdkflutterplugin.startTransaction(
        _amount,
        reference,
        _currency,
      );
      if (!mounted) return;
      if (start.resultType == HaloStartTransactionResultType.started) {
        setState(() {
          _phase = TransactionPhase.inProgress;
          _message = 'Tap card on the back of the phone';
        });
      } else {
        _fail(
          TransactionMessages.startError(start.resultType, currency: _currency),
        );
      }
    } on PlatformException catch (e) {
      _fail('Could not start transaction: ${e.message ?? e.code}');
    }
  }

  void _onUiMessage(HaloUIMessage message) {
    if (!mounted || !_phase.isBusy) return;
    setState(() {
      _phase = TransactionPhase.inProgress;
      _message = TransactionMessages.uiMessage(message.msgId);
    });
  }

  void _onResult(HaloTransactionResult result) {
    if (!mounted) return;
    setState(() {
      _result = result;
      if (result.resultType == HaloTransactionResultType.approved) {
        _phase = TransactionPhase.approved;
        _message = 'Payment approved';
      } else {
        _phase = TransactionPhase.failed;
        _message = TransactionMessages.result(result.resultType);
      }
    });
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() {
      _phase = TransactionPhase.failed;
      _message = message;
    });
  }

  Future<void> _cancel() async {
    try {
      await Sdkflutterplugin.cancelTransaction();
    } on PlatformException catch (e) {
      debugPrint('cancelTransaction failed: ${e.message}');
    }
    // A cancelled result normally arrives via onHaloTransactionResult; this
    // covers the case where the transaction never got going.
    if (mounted && _phase == TransactionPhase.starting) {
      _fail('Transaction cancelled');
    }
  }

  void _finish() {
    widget.cart.clear();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = _phase.isBusy;
    return PopScope(
      // Block back navigation mid-transaction; the user must cancel first.
      canPop: !isBusy,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Card Payment'),
            centerTitle: true,
            automaticallyImplyLeading: !isBusy,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'R${_amount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TransactionStatusIcon(phase: _phase),
                  const SizedBox(height: 24),
                  Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (_phase == TransactionPhase.approved)
                    TransactionReceipt(result: _result),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 32.0,
            ),
            child: TransactionActions(
              phase: _phase,
              onCancel: _cancel,
              onDone: _finish,
              onBack: () => Navigator.pop(context),
              onRetry: _startTransaction,
            ),
          ),
        ),
      ),
    );
  }
}
