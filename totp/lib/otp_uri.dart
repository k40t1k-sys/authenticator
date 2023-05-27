import 'totp_algorithm.dart';
import 'totp_item.dart';

// Parses TOTP key URI into TOTPItems.
class OtpUri {
  // Parse a TOTP key URI aand returns a TOTP object
  static TOTPItem fromUri(String uri) {
    var parsed = Uri.parse(uri);

    if (parsed.scheme != "otpauth") {
      throw const FormatException("Not OTP Uri");
    }
    if (parsed.authority != "totp" && parsed.authority != "hotp") {
      throw const FormatException("Unsupported Authority");
    }

    if (parsed.pathSegments.length > 1) {
      throw const FormatException("Should have more than 1 path segment");
    }

    var pathSplit = parsed.pathSegments[0].split(':');
    var issuer = pathSplit[0];
    var accountName = pathSplit.length > 1 ? pathSplit[1] : '';

    var algorithm = "sha1";
    var digits = 6;
    var period = 30;
    var secret = "";

    if (!parsed.queryParameters.containsKey("secret")) {
      throw const FormatException("Query parameter does not contain secret.");
    }
    secret = parsed.queryParameters["secret"]!;

    if (parsed.queryParameters.containsKey("algorithm")) {
      algorithm = parsed.queryParameters["algorithm"]!.toLowerCase();
      if (algorithm != "sha1" &&
          algorithm != "sha256" &&
          algorithm != "sha512") {
        throw const FormatException("Unrecognaized Algorithm");
      }
    }

    if (parsed.queryParameters.containsKey("digits")) {
      digits = int.parse(parsed.queryParameters["digits"]!);
    }

    if (parsed.queryParameters.containsKey("period")) {
      period = int.parse(parsed.queryParameters["period"]!);
    }

    try {
      return TOTPItem.newTOTPItem(secret, digits, period,
          OtpHashAlgorithm.fromString(algorithm), issuer, accountName);
    } catch (error) {
      throw const FormatException("incorrect Parameters");
    }
  }
}
