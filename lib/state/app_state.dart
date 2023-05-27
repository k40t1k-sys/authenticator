import 'package:totp/totp.dart';

// Represents app state
class AppState {
  // Initialise state on load
  AppState(this._items);

  // List of TOTP items (internal implementattion).
  final List<TOTPItem> _items;

  // TOTP items as list.
  List<TOTPItem> get items => _items;

  // Add TOTP item to the list.
  void addItem(TOTPItem item) {
    // prevent duplicacy.
    if (_items.contains(item)) {
      throw Exception("DUPLICATE_ACCOUNT");
    }
    // prevent id collision
    if (_items.any((itemsItem) => itemsItem.id == item.id)) {
      throw Exception("ID_COLLISION");
    }
    items.add(item);
  }

  // Replace list of TOTP items.
  void replaceItems(List<TOTPItem> items) {
    _items.clear();
    _items.addAll(items);
  }

  // Removes a TOTP item from the list.
  void removeItems(TOTPItem item) {
    _items.remove(item);
  }

  // Replaces an old TOTP item with a new one.
  void replaceItem(TOTPItem oldItem, TOTPItem newItem) {
    var index = _items.indexOf(oldItem);
    _items.removeAt(index);
    _items.insert(index, newItem);
  }
}
