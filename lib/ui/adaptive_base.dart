import 'package:flutter/widgets.dart';
import './adaptive.dart';

abstract class AdaptiveBase<A extends Widget, C extends Widget>
    extends StatelessWidget {
  const AdaptiveBase({super.key});

  @override
  Widget build(BuildContext context) {
    return isPlatformAndroid()
        ? createAndroidWidget(context)
        : createCupertinoWidget(context);
  }

  A createAndroidWidget(BuildContext context);
  C createCupertinoWidget(BuildContext context);
}
