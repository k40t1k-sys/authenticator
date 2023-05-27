import 'package:authenticator/pages/pages.dart';
// import 'package:authenticator/ui/adaptive.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:authenticator/state/state.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:totp/totp.dart';
// import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static const stateFilename = "items.json";
  final Repository repository = Repository(FileStorage(stateFilename));

  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Stores state of app
  late AppState appState;
  // final LocalAuthentication auth = LocalAuthentication();
  // _SupportState _supportState = _SupportState.unknown;
  // bool? _canCheckBiometrics;
  // List<BiometricType>? _availableBiometrics;
  // String _authorized = 'Not Authorized';
  // bool _isAuthenticating = false;

  @override
  void initState() {
    // Load initial state
    widget.repository.loadState().then((items) {
      super.setState(() {
        appState = AppState(items);
      });
    });
    super.initState();
    // auth.isDeviceSupported().then(
    //	  (bool isSupported) => setState(() => _supportState = isSupported
    //           ? _SupportState.supported
    //           : _SupportState.unsupported),
    // );
  }

  // Locale Information
  final Iterable<Locale> supportedLocales = [const Locale('en')];
  final Iterable<LocalizationsDelegate> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate
  ];

  // Future<void> _checkBiometrics() async {
  //   late bool canCheckBiometrics;
  //   try {
  //     canCheckBiometrics = await auth.canCheckBiometrics;
  //   } catch (e) {
  //     canCheckBiometrics = false;
  //     // print(e);
  //   }
  //   if (!mounted) {
  //     return;
  //   }

  //   setState(() {
  //     _canCheckBiometrics = canCheckBiometrics;
  //   });
  // }

  // Future<void> _getAvailableBiometrics() async {
  //   late List<BiometricType> availableBiometrics;
  //   try {
  //     availableBiometrics = await auth.getAvailableBiometrics();
  //   } catch (e) {
  //     availableBiometrics = <BiometricType>[];
  //     // print(e);
  //   }
  //   if (!mounted) {
  //     return;
  //   }

  //   setState(() {
  //     _availableBiometrics = availableBiometrics;
  //   });
  // }

  // Future<void> _authenticate() async {
  //   bool authenticated = false;
  //   try {
  //     setState(() {
  //       _isAuthenticating = true;
  //       _authorized = 'Authenticating';
  //     });
  //     authenticated = await auth.authenticate(
  //       localizedReason: 'Let OS determine authentication method',
  //       options: const AuthenticationOptions(
  //         stickyAuth: true,
  //       ),
  //     );
  //     setState(() {
  //       _isAuthenticating = false;
  //     });
  //   } catch (e) {
  //     // print(e);
  //     setState(() {
  //       _isAuthenticating = false;
  //       _authorized = 'Error - ${e.toString()}';
  //     });
  //     return;
  //   }
  //   if (!mounted) {
  //     return;
  //   }

  //   setState(
  //       () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  // }

  // Future<void> _authenticateWithBiometrics() async {
  //   bool authenticated = false;
  //   try {
  //     setState(() {
  //       _isAuthenticating = true;
  //       _authorized = 'Authenticating';
  //     });
  //     authenticated = await auth.authenticate(
  //       localizedReason:
  //           'Scan your fingerprint (or face or whatever) to authenticate',
  //       options: const AuthenticationOptions(
  //         stickyAuth: true,
  //         biometricOnly: true,
  //       ),
  //     );
  //     setState(() {
  //       _isAuthenticating = false;
  //       _authorized = 'Authenticating';
  //     });
  //   } catch (e) {
  //     // print(e);
  //     setState(() {
  //       _isAuthenticating = false;
  //       _authorized = 'Error - ${e.toString()}';
  //     });
  //     return;
  //   }
  //   if (!mounted) {
  //     return;
  //   }

  //   final String message = authenticated ? 'Authorized' : 'Not Authorized';
  //   setState(() {
  //     _authorized = message;
  //   });
  // }

  // Future<void> _cancelAuthentication() async {
  //   await auth.stopAuthentication();
  //   setState(() => _isAuthenticating = false);
  // }

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    // TargetPlatform platform = getPlatform();

    // if (platform == TargetPlatform.android) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AndroidHomePage(appState.items, addItem),
        '/edit': (context) => AndroidEditPage(
            List<TOTPItem>.from(appState.items), itemsChanged, replaceItems),
        '/add': (context) => AddPage(addItem),
        '/add/scan': (context) => const ScanQRPage(),
        '/settings': (context) => SettingsPage()
      },
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
    );
    // } else {
    //   throw Exception("Unrecognized Platform");
    // }
  }

  void addItem(TOTPItem item) {
    setState(() {
      appState.addItem(item);
    });
    widget.repository.saveState(appState.items);
  }

  void replaceItems(List<TOTPItem> items) {
    setState(() {
      appState.replaceItems(items);
    });
    widget.repository.saveState(appState.items);
  }

  bool itemsChanged(List<TOTPItem> items) {
    return !const ListEquality().equals(appState.items, items);
  }
}

// enum _SupportState {
//   unknown,
//   supported,
//   unsupported,
// }

// return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: ListView(
//           padding: const EdgeInsets.only(top: 30),
//           children: <Widget>[
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 if (_supportState == _SupportState.unknown)
//                   const CircularProgressIndicator()
//                 else if (_supportState == _SupportState.supported)
//                   const Text('This device is supported')
//                 else
//                   const Text('This device is not supported'),
//                 const Divider(height: 100),
//                 Text('Can check biometrics: $_canCheckBiometrics\n'),
//                 ElevatedButton(
//                   onPressed: _checkBiometrics,
//                   child: const Text('Check biometrics'),
//                 ),
//                 const Divider(height: 100),
//                 Text('Available biometrics: $_availableBiometrics\n'),
//                 ElevatedButton(
//                   onPressed: _getAvailableBiometrics,
//                   child: const Text('Get available biometrics'),
//                 ),
//                 const Divider(height: 100),
//                 Text('Current State: $_authorized\n'),
//                 if (_isAuthenticating)
//                   ElevatedButton(
//                     onPressed: _cancelAuthentication,
//                     // TODO(goderbauer): Make this const when this package requires Flutter 3.8 or later.
//                     // ignore: prefer_const_constructors
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: const <Widget>[
//                         Text('Cancel Authentication'),
//                         Icon(Icons.cancel),
//                       ],
//                     ),
//                   )
//                 else
//                   Column(
//                     children: <Widget>[
//                       ElevatedButton(
//                         onPressed: _authenticate,
//                         // TODO(goderbauer): Make this const when this package requires Flutter 3.8 or later.
//                         // ignore: prefer_const_constructors
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: const <Widget>[
//                             Text('Authenticate'),
//                             Icon(Icons.perm_device_information),
//                           ],
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: _authenticateWithBiometrics,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             Text(_isAuthenticating
//                                 ? 'Cancel'
//                                 : 'Authenticate: biometrics only'),
//                             const Icon(Icons.fingerprint),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
