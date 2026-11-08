import 'dart:async';

import 'package:flutter/material.dart';
import 'package:halo_sdk_flutter_plugin/model/halo_attestation_health_result.dart';
import 'package:halo_sdk_flutter_plugin/model/halo_initialization_result.dart';
import 'package:halo_sdk_flutter_plugin/model/halo_initialization_result_type.dart';
import 'package:halo_sdk_flutter_plugin/model/halo_transaction_result.dart';
import 'package:halo_sdk_flutter_plugin/model/halo_transaction_result_type.dart';
import 'package:halo_sdk_flutter_plugin/model/halo_ui_message.dart';
import 'package:halo_sdk_flutter_plugin/model/halo_ui_message_id.dart';
import 'package:halo_sdk_flutter_plugin/model/i_halo_callbacks.dart';

import 'jwt_token.dart';

/// Single callbacks instance registered with the Halo SDK. Screens listen to
/// [initResult], [uiMessages] and [transactionResults] to react to SDK events.
class HaloCallbacks implements IHaloCallbacks {
  HaloCallbacks._();
  static final HaloCallbacks instance = HaloCallbacks._();

  final ValueNotifier<HaloInitializationResult?> initResult = ValueNotifier(
    null,
  );
  final _uiMessages = StreamController<HaloUIMessage>.broadcast();
  final _transactionResults =
      StreamController<HaloTransactionResult>.broadcast();

  Stream<HaloUIMessage> get uiMessages => _uiMessages.stream;
  Stream<HaloTransactionResult> get transactionResults =>
      _transactionResults.stream;

  bool get isReady {
    final type = initResult.value?.resultType;
    return type == HaloInitializationResultType.initialized ||
        type == HaloInitializationResultType.initializedWithoutConfigs;
  }

  @override
  void onAttestationError(HaloAttestationHealthResult details) {
    debugPrint("example app: attestation error: $details");
  }

  /// Prints a hard-to-miss block in the console / logcat (`flutter` tag).
  static void _banner(String title, [List<String> lines = const []]) {
    const bar = '##################################################';
    debugPrint(bar);
    debugPrint('##  $title');
    for (final line in lines) {
      debugPrint('##    $line');
    }
    debugPrint(bar);
  }

  @override
  void onHaloTransactionResult(HaloTransactionResult result) {
    debugPrint("example app: transaction result: ${result.resultType}");
    final approved = result.resultType == HaloTransactionResultType.approved;
    _banner(
      approved
          ? '✅ PAYMENT APPROVED'
          : '❌ TRANSACTION ENDED: ${result.resultType.name}',
      [
        'errorCode: ${result.errorCode.name}',
        if (result.errorDetails.isNotEmpty)
          'details: ${result.errorDetails.join('; ')}',
        'merchantRef: ${result.merchantTransactionReference}',
        if (result.receipt != null)
          'card: ${result.receipt!.maskedPAN} (${result.receipt!.association})',
      ],
    );
    _transactionResults.add(result);
  }

  @override
  void onHaloUIMessage(HaloUIMessage message) {
    debugPrint("example app: UI message: ${message.msgId}");
    switch (message.msgId) {
      case HaloUiMessageId.presentCard:
        _banner('📡 WAITING FOR CARD - NFC reader is on, tap card now');
      case HaloUiMessageId.processing:
        _banner('💳 CARD TAPPED - card detected, reading...');
      case HaloUiMessageId.cardReadOK_RemoveCard:
        _banner('💳 CARD READ OK - card can be removed');
      default:
        _banner('ℹ️ SDK MESSAGE: ${message.msgId.name}');
    }
    _uiMessages.add(message);
  }

  @override
  void onInitializationResult(HaloInitializationResult result) {
    debugPrint("example app: initialization message: ${result.resultType}");
    initResult.value = result;
  }

  @override
  void onRequestJWT(void Function(String jwt) callback) {
    debugPrint("example app: onRequestJWT");
    var jwt = JwtToken.getJwt();
    callback(jwt);
  }

  @override
  void onSecurityError(errorCode) {
    debugPrint("example app: security error: $errorCode");
  }

  @override
  void onCameraControlLost() {
    debugPrint("example app: camera control lost");
  }
}
