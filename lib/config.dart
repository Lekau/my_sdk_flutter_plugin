/// Values are injected at build time via:
///   flutter run --dart-define-from-file=lib/dev.env
class Config {
  static const String _privateKeyPem = String.fromEnvironment('PRIVATEKEYPEM');
  static const String issuer = String.fromEnvironment('ISSUER');
  static const String username = String.fromEnvironment('USERNAME');
  static const String merchantId = String.fromEnvironment('MERCHANTID');
  static const String host = String.fromEnvironment('HOST');
  static const String aud = String.fromEnvironment('AUD');
  static const String ksk = String.fromEnvironment('KSK');

  // The .env stores the PEM on one line with escaped `\n` sequences.
  static String get privateKeyPem => _privateKeyPem.replaceAll(r'\n', '\n');
}
