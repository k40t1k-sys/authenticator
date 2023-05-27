import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
import 'package:totp/totp.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:authenticator/ui/adaptive.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

/// Page for adding accounts by scanning QR.
class ScanQRPage extends StatefulWidget {
  const ScanQRPage({super.key});

  @override
  State<StatefulWidget> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  @override
  void initState() {
    super.initState();

    // Trigger scan
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final value = await _scan();
        // Parse scanned value into item and pop
        var item = TOTPItem.fromUri(value);
        // Pop until scan page
        Navigator.popUntil(context, ModalRoute.withName('/add/scan'));
        // Pop with scanned item
        Navigator.of(context).pop(item);
      } catch (e) {
        await showAdaptiveDialog(
          context,
          title: Text(AppLocalizations.of(context)!.error),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.ok),
            )
          ],
        );
        Navigator.popUntil(context, ModalRoute.withName('/add/scan'));
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(AppLocalizations.of(context)!.addScanQR),
      body: const Center(),
    );
  }

  // Scans and returns scanned QR code
  // Adapted from documentation of flutter_barcode_reader
  Future _scan() async {
    try {
      var barcode = await BarcodeScanner.scan();
      return barcode.rawContent;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        return Future.error(
            AppLocalizations.of(context)!.errNoCameraPermission);
      } else {
        return Future.error('${AppLocalizations.of(context)!.errUnknown} $e');
      }
    } on FormatException {
      return Future.error(AppLocalizations.of(context)!.errIncorrectFormat);
    } catch (e) {
      return Future.error('${AppLocalizations.of(context)!.errUnknown} $e');
    }
  }
}
