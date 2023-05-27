import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:authenticator/ui/adaptive.dart' show AppScaffold;
import 'package:package_info/package_info.dart' show PackageInfo;

/// Settings page.
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(AppLocalizations.of(context)!.settingsTitle),
      body: Column(
        children: <Widget>[
          // App Info
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // App image
                Container(
                  height: 125,
                  width: 150,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('graphics/icon.png'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Name
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Text(AppLocalizations.of(context)!.appName,
                              style: const TextStyle(fontSize: 25))),
                      // Version of app
                      FutureBuilder(
                        future: PackageInfo.fromPlatform(),
                        builder: (BuildContext context,
                            AsyncSnapshot<PackageInfo> snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data!.version,
                                style: const TextStyle(fontSize: 14));
                          }
                          return Text(AppLocalizations.of(context)!.loading);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
