import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import './config.dart';

class JwtToken {
  static String getJwt() {
    final jwt = JWT(
      {
        'aud_fingerprints': Config.aud,
        'ksk_pin': Config.ksk,
        'usr': Config.username,
      },
      audience: Audience([Config.host]),
      issuer: Config.issuer,
      subject: Config.merchantId,
    );

    final key = RSAPrivateKey(Config.privateKeyPem);
    final token = jwt.sign(key, algorithm: JWTAlgorithm.RS512);
    return token;
  }
}
