// import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './adaptive.dart';

class AppScaffold extends StatelessWidget {
  final Text title;
  final Widget body;
  final CupertinoNavigationBar? cupertinoNavigationBar;

  const AppScaffold(
      {required this.title,
      this.cupertinoNavigationBar,
      required this.body,
      super.key});

  @override
  Widget build(BuildContext context) {
    if (isPlatformAndroid()) {
      return Scaffold(
        appBar: AppBar(
          title: title,
        ),
        body: body,
      );
    } else {
      return CupertinoPageScaffold(
          navigationBar: cupertinoNavigationBar,
          child: const Text('This is the point of failure.'));
    }
  }
}
