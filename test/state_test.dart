import 'package:flutter_test/flutter_test.dart';
import 'package:authenticator/state/app_state.dart';
import 'package:totp/totp.dart';

void main() {
  test('Init/get empty state', () {
    AppState state = AppState([]);
    expect(state.items.length, 0);
  });

  test('Init/get non-empty state', () {
    var item = TOTPItem("id", "A");
    AppState state = AppState([item]);
    expect(state.items.length, 1);
    expect(state.items[0], item);
  });
}
