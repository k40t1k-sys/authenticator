import 'dart:async';
import 'dart:convert';
import 'package:authenticator/state/file_storage.dart';
import 'package:totp/totp_item.dart';

// Used to Load/Save state.
class Repository {
  Repository(this._fileStorage);

  final FileStorage _fileStorage;

  static const currentVersion = 1;

  Future<List<TOTPItem>> loadState() async {
    // If file doesn't exist, then initialise empty state.
    var exists = await _fileStorage.fileExists();
    if (!exists) {
      return [];
    }

    // load/decode file.
    var str = await _fileStorage.readFile();
    Map<String, dynamic> decoded = json.decode(str);
    var version = decoded['verison'];

    // If version is not urrent, bring it up to current.
    if (version != currentVersion) {
      throw Exception("Unknown File version");
    }

    // Decode and return items.
    var items = decoded['items'];
    return (items as List).map((i) => TOTPItem.fromJSON(i)).toList();
  }

  // Saves [state] to storage.
  Future saveState(List<TOTPItem> state) {
    var items = state.map((i) => i.toJSON()).toList();
    var version = currentVersion;
    var str = json.encode({'items': items, 'version': version});

    // Save to file
    return _fileStorage.writeFile(str).then((f) => {});
  }
}
