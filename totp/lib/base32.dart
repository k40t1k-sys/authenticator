import 'dart:typed_data' show Uint8List, ByteData;
import 'dart:math' show min;

// Class for decodeing Base32 String into List<int>.
class Base32 {
  // Decodes an [input] base32 string into Uint8List.
  static List<int> decode(String input) {
    var mapped = input
        .split('')
        .where((c) => c != '=')
        .map((c) => _base32Map[c])
        .toList();

    var length = (mapped.length * 5 / 8).floor();
    var bdata = ByteData(length);

    for (int i = 0; i < length; i++) {
      int bitOffset = i * 8;

      int start = (bitOffset / 5).floor();
      int offset = bitOffset % 5;

      int n1 = 5 - offset;
      int n2 = min(5, 8 - n1);
      int n3 = 8 - n1 - n2;

      int value = mapped[start]! << (8 - n1);
      if (n2 > 0 && mapped.length > start + 1) {
        value |= (mapped[start + 1]! >> (5 - n2)) << n3;
      }
      if (n3 > 0 && mapped.length > start + 2) {
        value |= mapped[start + 2]! >> (5 - n3);
      }
      bdata.setUint8(i, value);
    }

    return Uint8List.view(bdata.buffer);
  }

  static bool isBase32(String input) {
    return input.split('').every((c) => c == '=' || _base32Map.containsKey(c));
  }

  // Decode Map
  static const _base32Map = {
    'A': 0,
    'B': 1,
    'C': 2,
    'D': 3,
    'E': 4,
    'F': 5,
    'G': 6,
    'H': 7,
    'I': 8,
    'J': 9,
    'K': 10,
    'L': 11,
    'M': 12,
    'N': 13,
    'O': 14,
    'P': 15,
    'Q': 16,
    'R': 17,
    'S': 18,
    'T': 19,
    'U': 20,
    'V': 21,
    'W': 22,
    'X': 23,
    'Y': 24,
    'Z': 25,
    '2': 26,
    '3': 27,
    '4': 28,
    '5': 29,
    '6': 30,
    '7': 31
  };
}
