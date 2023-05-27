import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
export './adaptive_dialog.dart';
export './app_scaffold.dart';

TargetPlatform getPlatform() {
  TargetPlatform result = defaultTargetPlatform;
  return result;
}

bool isPlatformAndroid() {
  return getPlatform() == TargetPlatform.android;
}

Color getScaffoldColor(BuildContext context) {
  return isPlatformAndroid()
      ? Theme.of(context).scaffoldBackgroundColor
      : CupertinoTheme.of(context).scaffoldBackgroundColor;
}
