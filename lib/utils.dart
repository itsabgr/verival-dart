import 'dart:typed_data';
import 'dart:math';

void main() {
  {
    var n = Random().nextInt(555) + 10;
    var b = rand(n);
    var b2 = clone(b);
    assert(b.length == n && n == b2.length);
    var b3 = Uint8List(n);
    assert(2 == eq([b2, b, b3]));
  }
}

Uint8List clone(Uint8List b) {
  return Uint8List.fromList(b);
}

final _defaultSecureRandom = Random.secure();

int eq(List<List<dynamic>> arr) {
  for (var i = 1; i < arr.length; i++) {
    if (arr[0].length != arr[i].length) {
      return i;
    }
    for (var j = 1; j < arr[0].length; j++) {
      if (arr[0][j] != arr[i][j]) {
        return i;
      }
    }
  }
  return 0;
}

int btou64(ByteBuffer b) {
  return ByteData.view(b).getUint64(0, Endian.big);
}

Uint8List u64tob(int n) {
  var b = Uint8List(8);
  ByteData.view(b.buffer).setUint64(0, n, Endian.big);
  return b;
}

Uint8List rand(int length) {
  var b = Uint8List(length);
  for (var i = 0; i < b.length; i++) {
    b[i] = _defaultSecureRandom.nextInt(256);
  }
  return b;
}

int timestamp() {
  return DateTime.now().toUtc().millisecondsSinceEpoch;
}
