import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './adaptive_base.dart';
import './adaptive.dart';

class AdaptiveAndroidDialogActionData {
  final VoidCallback onPressed;
  final Widget child;

  AdaptiveAndroidDialogActionData(
      {required this.onPressed, required this.child});
}

class AdaptiveCupertinoDialogActionData {
  final VoidCallback onPressed;
  final Widget child;

  AdaptiveCupertinoDialogActionData(
      {required this.onPressed, required this.child});
}

class AdaptiveDialogAction
    extends AdaptiveBase<TextButton, CupertinoDialogAction> {
  final AdaptiveAndroidAlertDialogData androidData;
  final AdaptiveCupertinoAlertDialogData cupertinoData;
  final VoidCallback onPressed;
  final Widget child;

  const AdaptiveDialogAction(
      this.androidData, this.cupertinoData, this.onPressed, this.child,
      {super.key});

  @override
  TextButton createAndroidWidget(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
    );
  }

  @override
  CupertinoDialogAction createCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      onPressed: onPressed,
      child: child,
    );
  }
}

// class AdaptiveDialogAction
//     extends AdaptiveBase<TextButton, CupertinoDialogAction> {
//   AdaptiveAndroidDialogActionData androidData;
//   AdaptiveCupertinoDialogActionData cupertinoData;
//   VoidCallback onPressed;
//   Widget child;

//   AdaptiveDialogAction(
//       this.androidData, this.cupertinoData, this.onPressed, this.child,
//       {super.key});

//   @override
//   TextButton createAndroidWidget(BuildContext context) => TextButton(
//       key: androidData.key,
//       onPressed: androidData.onPressed,
//       child: androidData.child);

//   @override
//   CupertinoDialogAction createCupertinoWidget(BuildContext context) =>
//       CupertinoDialogAction(
//           onPressed: cupertinoData.onPressed, child: cupertinoData.child);
// }

class AdaptiveAndroidAlertDialogData {
  final Key key;
  final Widget title;
  final EdgeInsetsGeometry titlePadding;
  final Widget content;
  final EdgeInsetsGeometry contentPadding;
  final List<Widget> actions;

  AdaptiveAndroidAlertDialogData(
      {required this.key,
      required this.title,
      required this.titlePadding,
      required this.content,
      required this.contentPadding,
      required this.actions});
}

class AdaptiveCupertinoAlertDialogData {
  final Key key;
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  AdaptiveCupertinoAlertDialogData(
      {required this.key,
      required this.title,
      required this.content,
      required this.actions});
}

Future<dynamic> showAdaptiveDialog<T>(BuildContext context,
    {Key? key,
    Widget? title,
    Widget? content,
    required List<Widget> actions,
    AdaptiveAndroidAlertDialogData? androidData,
    AdaptiveCupertinoAlertDialogData? cupertinoData}) async {
  var platform = getPlatform();
  if (platform == TargetPlatform.android) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            key: key,
            title: title,
            titlePadding: androidData!.titlePadding,
            content: content,
            contentPadding: androidData.contentPadding,
            actions: actions,
          );
        });
  } else {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            key: key,
            title: title,
            content: content,
            actions: actions,
          );
        });
  }
}

// Future<dynamic> showAdaptiveDialog<T>(BuildContext context,
//     {Key? key,
//     Widget? title,
//     Widget? content,
//     required List<Widget> actions,
//     AdaptiveAndroidAlertDialogData? androidData,
//     AdaptiveCupertinoAlertDialogData? cupertinoData}) async {
//   var platform = getPlatform();
//   var alertDialog = platform == TargetPlatform.android
//       ? AlertDialog(
//           key: key,
//           title: title,
//           titlePadding: androidData!.titlePadding,
//           content: content,
//           contentPadding: androidData.contentPadding,
//           actions: actions,
//         )
//       : CupertinoAlertDialog(
//           key: key,
//           title: title,
//           content: content,
//           actions: actions,
//         );

//   if (platform == TargetPlatform.android) {
//     return showDialog(context: context, builder: (_) => alertDialog);
//   } else {
//     return showCupertinoDialog(context: context, builder: (_) => alertDialog);
//   }
// }
