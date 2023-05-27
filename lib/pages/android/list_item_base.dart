import 'package:flutter/widgets.dart';
import 'package:totp/totp.dart';

abstract class TOTPListItemBase extends StatefulWidget {
  const TOTPListItemBase(this.item, {super.key});

  final TOTPItem item;

  static int get _secondsSinceEpoch {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  double get indicatorValue {
    return (_secondsSinceEpoch % item.period) / item.period;
  }

  String get codeUnformatted {
    return item.getCode(_secondsSinceEpoch);
  }

  String get code {
    return item.getPrettyCode(_secondsSinceEpoch);
  }

  @override
  State<StatefulWidget> createState();
}
