import 'dart:typed_data';
import 'dart:math';
import 'package:verival/utils.dart';
import 'package:test/test.dart';

void main() {
  test("utils", () {
    {
      var n = Random().nextInt(555) + 10;
      var b = rand(n);
      var b2 = clone(b);
      assert(b.length == n && n == b2.length);
      var b3 = Uint8List(n);
      assert(2 == eq([b2, b, b3]));
    }
  });
}
