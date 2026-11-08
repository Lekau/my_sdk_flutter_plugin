import 'package:halo_sdk_flutter_plugin/model/halo_start_transaction_result_type.dart';
import 'package:halo_sdk_flutter_plugin/model/halo_transaction_result_type.dart';
import 'package:halo_sdk_flutter_plugin/model/halo_ui_message_id.dart';

/// Maps Halo SDK result/message types to user-facing text.
class TransactionMessages {
  const TransactionMessages._();

  static String startError(
    HaloStartTransactionResultType type, {
    required String currency,
  }) {
    switch (type) {
      case HaloStartTransactionResultType.nfcDisabledError:
        return 'NFC is turned off. Enable NFC in settings and try again.';
      case HaloStartTransactionResultType.notInitialized:
        return 'Payment SDK is not initialised yet.';
      case HaloStartTransactionResultType.invalidJWT:
        return 'Authentication failed (invalid JWT).';
      case HaloStartTransactionResultType.invalidCurrency:
        return 'Unsupported currency: $currency';
      case HaloStartTransactionResultType.rootedDevice:
      case HaloStartTransactionResultType.instrumentedDevice:
      case HaloStartTransactionResultType.debuggedDevice:
        return 'This device failed security checks ($type).';
      default:
        return 'Could not start transaction ($type).';
    }
  }

  static String uiMessage(HaloUiMessageId id) {
    switch (id) {
      case HaloUiMessageId.presentCard:
        return 'Tap card on the back of the phone';
      case HaloUiMessageId.processing:
        return 'Processing...';
      case HaloUiMessageId.cardReadOK_RemoveCard:
        return 'Card read. You can remove the card.';
      case HaloUiMessageId.seePhoneForInstructions_ThenTapAgain:
        return 'See your phone for instructions, then tap again';
      case HaloUiMessageId.authorisingWait:
        return 'Authorising, please wait...';
      case HaloUiMessageId.tryAgain:
        return 'Please try again';
      case HaloUiMessageId.tryAnotherCard:
        return 'Please try another card';
    }
  }

  static String result(HaloTransactionResultType type) {
    switch (type) {
      case HaloTransactionResultType.declined:
        return 'Payment declined';
      case HaloTransactionResultType.cardTapTimeOutExpired:
        return 'Timed out waiting for a card';
      case HaloTransactionResultType.cancelled:
        return 'Transaction cancelled';
      case HaloTransactionResultType.networkError:
        return 'Network error, please try again';
      case HaloTransactionResultType.nfcDisabledError:
        return 'NFC is turned off';
      case HaloTransactionResultType.tryAnotherCard:
        return 'Please try another card';
      default:
        return 'Transaction failed ($type)';
    }
  }
}
