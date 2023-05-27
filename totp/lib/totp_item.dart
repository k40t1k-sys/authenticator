import 'package:uuid/uuid.dart';
import 'base32.dart';
import 'totp_algorithm.dart';
import 'otp_uri.dart';

// Represents a TOTP item and associated information.
class TOTPItem {
  TOTPItem(this.id, this.secret,
      [this.digits = 6,
      this.period = 30,
      this.algorithm = OtpHashAlgorithm.sha1,
      this.issuer = "",
      this.accountName = ""])
      : assert(Base32.isBase32(secret) && secret != ""),
        assert(digits == 6 || digits == 8),
        assert(period > 0);

  final String id;

  final String accountName;

  final String issuer;

  final String secret;

  final int digits;

  final int period;

  final OtpHashAlgorithm algorithm;

  // create a new TOTP algorithm.
  static TOTPItem newTOTPItem(String secret,
      [int digits = 6,
      int period = 60,
      OtpHashAlgorithm algorithm = OtpHashAlgorithm.sha1,
      String issuer = "",
      String accountName = ""]) {
    String id = const Uuid().v4();
    return TOTPItem(id, secret, digits, period, algorithm, issuer, accountName);
  }

  static TOTPItem fromUri(String uri) {
    return OtpUri.fromUri(uri);
  }

  String getPrettyCode(int time) {
    return TOTP.prettyValue(
        TOTP.generateCode(time, secret, digits, period, algorithm));
  }

  String getCode(int time) {
    return TOTP.generateCode(time, secret, digits, period, algorithm);
  }

  String get placeHolder {
    if (digits == 8) {
      return '.... ....';
    }
    return '... ...';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TOTPItem &&
          accountName == other.accountName &&
          issuer == other.issuer &&
          secret == other.secret &&
          digits == other.digits &&
          period == other.period &&
          algorithm == other.algorithm;

  @override
  int get hashCode =>
      accountName.hashCode ^
      issuer.hashCode ^
      period.hashCode ^
      digits.hashCode ^
      algorithm.hashCode ^
      secret.hashCode;

  TOTPItem.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        accountName = json['acountName'],
        issuer = json['issuer'],
        period = json['period'],
        digits = json['digits'],
        algorithm = json['algorithm'],
        secret = json['secret'];

  Map<String, dynamic> toJSON() => {
        'id': id,
        'accountName': accountName,
        'issuer': issuer,
        'secret': secret,
        'digits': digits,
        'period': period,
        'algorithm': algorithm
      };
}
